package com.dgis.map.android_auto

import com.dgis.map.map_api.FavouriteItemMessage
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
