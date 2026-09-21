package com.dgis.map.android_auto

import com.dgis.map.map_api.FavouriteItemMessage
import ru.dgis.sdk.DgisObjectId
import ru.dgis.sdk.coordinates.GeoPoint


data class FavouritesParams (
    val items: List<FavouriteItem> = emptyList(),
    val home: FavouriteItem? = null,
    val work: FavouriteItem? = null
)

data class FavouriteItem (
    val id: String,
    val title: String,
    val subtitle: String,
    val coordinates: GeoPoint,
    val iconResId: Int? = null,
)

fun FavouriteItemMessage.toFavouriteItem(): FavouriteItem {
    return FavouriteItem(
        id = id,
        title = title,
        subtitle = subtitle,
        coordinates = GeoPoint(
            coordinates.latitude,
            coordinates.longitude,
        ),
    )
}

/**
 * Flutter sends [FavouriteItemMessage.id] as the favourites entity id, "<objectId>-<entranceId>"
 * (see mapness `favourite_entity_id.dart`); older items and server echoes may still carry a bare
 * objectId. Returns null when no numeric objectId can be extracted, so the caller can skip the SDK
 * lookup instead of throwing NumberFormatException on the whole string.
 */
fun FavouriteItemMessage.toDgisObjectIdOrNull(): DgisObjectId? {
    val objectId = id.substringBefore('-').toLongOrNull() ?: return null
    val entranceId = id.substringAfter('-', "").toLongOrNull() ?: 0L
    return DgisObjectId(objectId = objectId, entranceId = entranceId)
}
