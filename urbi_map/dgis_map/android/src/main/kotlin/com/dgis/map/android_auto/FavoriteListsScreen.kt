package com.dgis.map.android_auto

import androidx.car.app.CarContext
import androidx.car.app.Screen
import androidx.car.app.ScreenManager
import androidx.car.app.annotations.ExperimentalCarApi
import androidx.car.app.constraints.ConstraintManager
import androidx.car.app.model.Action
import androidx.car.app.model.ActionStrip
import androidx.car.app.model.ItemList
import androidx.car.app.model.ListTemplate
import androidx.car.app.model.Row
import androidx.car.app.model.Template
import androidx.lifecycle.DefaultLifecycleObserver
import androidx.lifecycle.LifecycleOwner
import com.dgis.FlutterProvider
import com.dgis.map.R
import com.dgis.map.map_api.FavoriteListMessage
import com.dgis.map.map_api.FavoriteListPlaceRefMessage
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import ru.dgis.sdk.DgisObjectId
import ru.dgis.sdk.directory.DirectoryObject
import kotlin.math.min

class FavoriteListsScreen(
    carContext: CarContext,
    private val mapController: CarMapController,
) : Screen(carContext) {

    private val itemsLimit = carContext.getCarService(ConstraintManager::class.java)
        .getContentLimit(ConstraintManager.CONTENT_LIMIT_TYPE_LIST)

    private var lists: List<FavoriteListMessage> = emptyList()
    private val expandedListIds: MutableSet<String> = mutableSetOf()
    private var emptyRetryJob: Job? = null
    private var isLoading = true

    // Places are resolved natively (via `mapController`, independent of the phone's Flutter map)
    // instead of over Pigeon, so each place's `DirectoryObject` arrives asynchronously per-item
    // rather than all at once with the list payload.
    private val resolvedPlaces: MutableMap<String, DirectoryObject> = mutableMapOf()
    private val failedPlaceIds: MutableSet<String> = mutableSetOf()
    private val resolvingPlaceIds: MutableSet<String> = mutableSetOf()

    init {
        lifecycle.addObserver(
            object : DefaultLifecycleObserver {
                override fun onDestroy(owner: LifecycleOwner) {
                    emptyRetryJob?.cancel()
                }
            }
        )
        fetchFavoriteLists(retryOnEmpty = true)
    }

    private fun fetchFavoriteLists(retryOnEmpty: Boolean) {
        FlutterProvider.getHostFlutterApi(carContext).getFavoriteLists { result ->
            val fetched = result.getOrNull()?.lists ?: emptyList()
            lists = fetched
            // Only the very first response should dismiss the loading spinner — a later
            // background retry (see below) shouldn't flip it back on and cause a flicker.
            isLoading = false
            invalidate()
            // An empty result can be a genuinely empty account, or a transient failure on the
            // Dart side (e.g. the shared ProviderContainer was mid-rebuild). Re-check once.
            if (fetched.isEmpty() && retryOnEmpty) {
                emptyRetryJob = CoroutineScope(Dispatchers.Default).launch {
                    delay(3000)
                    withContext(Dispatchers.Main) { fetchFavoriteLists(retryOnEmpty = false) }
                }
            }
        }
    }

    private val actionStrip: ActionStrip
        get() {
            val closeAction = Action.Builder().setIcon(buildCarIcon(R.drawable.close_36))
                .setOnClickListener { carContext.getCarService(ScreenManager::class.java).pop() }
                .build()
            return ActionStrip.Builder().addAction(closeAction).build()
        }

    private val noListsRow: Row
        get() = Row.Builder()
            .setTitle(getString(R.string.no_favourites_title))
            .addText(getString(R.string.no_favourites_subtitle))
            .build()

    private fun buildItemList(): ItemList {
        val itemList = ItemList.Builder()
        if (lists.isEmpty()) {
            itemList.addItem(noListsRow)
            return itemList.build()
        }

        for (i in 0 until min(lists.size, itemsLimit)) {
            val list = lists[i]
            val isExpanded = expandedListIds.contains(list.id)
            itemList.addItem(
                Row.Builder()
                    .setImage(buildTintedCarIcon(R.drawable.bookmark, list.colorHex), Row.IMAGE_TYPE_ICON)
                    .setTitle(list.name)
                    .addText(list.subtitle.split(" • ").drop(1).joinToString(" • "))
                    .setBrowsable(true)
                    .setOnClickListener { toggleExpanded(list.id) }
                    .build()
            )
            if (isExpanded) {
                if (list.placeRefs.isEmpty()) {
                    itemList.addItem(
                        Row.Builder().setTitle(getString(R.string.favourites_list_empty_placeholder)).build()
                    )
                } else {
                    for (placeRef in list.placeRefs) {
                        itemList.addItem(buildPlaceRow(placeRef))
                    }
                }
            }
        }
        return itemList.build()
    }

    private fun buildPlaceRow(placeRef: FavoriteListPlaceRefMessage): Row {
        val resolved = resolvedPlaces[placeRef.placeId]
        if (resolved != null) {
            return Row.Builder()
                .setTitle(placeRef.customName ?: resolved.title)
                .addText(resolved.makeAddressString())
                .setOnClickListener { onItemTap(placeRef, resolved) }
                .build()
        }

        if (placeRef.placeId in failedPlaceIds) {
            return Row.Builder().setTitle(getString(R.string.favourite_place_unavailable)).build()
        }

        if (placeRef.placeId !in resolvingPlaceIds) {
            resolvePlace(placeRef)
        }
        return Row.Builder().setTitle(getString(R.string.favourite_place_resolving)).build()
    }

    // Resolves natively via `mapController` (the car session's own SDK `SearchManager`, unrelated
    // to the phone's Flutter map), instead of over Pigeon — this keeps favourite-place resolution
    // working even when the phone's own map screen was never opened this session.
    private fun resolvePlace(placeRef: FavoriteListPlaceRefMessage) {
        val objectId = placeRef.placeId.toLongOrNull()
        if (objectId == null) {
            failedPlaceIds.add(placeRef.placeId)
            return
        }

        resolvingPlaceIds.add(placeRef.placeId)
        mapController.searchByDirectoryObjectId(
            DgisObjectId(objectId = objectId),
            resultCallback = { result ->
                resolvingPlaceIds.remove(placeRef.placeId)
                if (result != null) resolvedPlaces[placeRef.placeId] = result else failedPlaceIds.add(placeRef.placeId)
                invalidate()
            },
            errorCallback = {
                resolvingPlaceIds.remove(placeRef.placeId)
                failedPlaceIds.add(placeRef.placeId)
                invalidate()
            },
        )
    }

    private fun toggleExpanded(listId: String) {
        if (!expandedListIds.add(listId)) {
            expandedListIds.remove(listId)
        } else {
            retryFailedPlaces(listId)
        }
        invalidate()
    }

    // Re-expanding a list is the user's retry gesture: clear this list's failed ids so
    // `buildPlaceRow` falls through to `resolvePlace` again instead of showing
    // "unavailable" forever (place resolution has no other in-session refresh path).
    private fun retryFailedPlaces(listId: String) {
        val list = lists.firstOrNull { it.id == listId } ?: return
        for (placeRef in list.placeRefs) {
            failedPlaceIds.remove(placeRef.placeId)
        }
    }

    private fun onItemTap(placeRef: FavoriteListPlaceRefMessage, directoryObject: DirectoryObject) {
        val params = directoryObject.toRoutePreviewParams().let {
            if (placeRef.customName != null) it.copy(name = placeRef.customName) else it
        }
        screenManager.push(RoutePreviewScreen(carContext, mapController, params))
    }

    @ExperimentalCarApi
    override fun onGetTemplate(): Template {
        val builder = ListTemplate.Builder().setHeaderAction(Action.BACK)
            .setTitle(getString(R.string.favourites_lists_title)).setActionStrip(actionStrip)
            .setLoading(isLoading)
        if (!isLoading) {
            builder.setSingleList(buildItemList())
        }
        return builder.build()
    }

    companion object {
        private const val tag = "FavoriteListsScreen"
    }
}
