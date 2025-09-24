package com.dgis.map.android_auto

import com.dgis.map.map_api.FavouriteItemMessage
import ru.dgis.sdk.DgisObjectId
import ru.dgis.sdk.coordinates.GeoPoint
import ru.dgis.sdk.directory.ContactInfo
import ru.dgis.sdk.directory.DirectoryObject
import ru.dgis.sdk.directory.RubricId

data class RoutePreviewParams(
    val name: String,
    val additionalInfo: String,
    val coordinates: GeoPoint?,
    val id: DgisObjectId? = null,
    val rubricIds: List<RubricId>? = null,
    val contactInfos: List<ContactInfo>? = null,
)

fun DirectoryObject.toRoutePreviewParams(): RoutePreviewParams {
    return RoutePreviewParams(
        name = title,
        additionalInfo = makeAddressString(),
        coordinates = if (markerPosition != null) GeoPoint(
            markerPosition!!.latitude.value,
            markerPosition!!.longitude.value,
        ) else null,
        id = id,
        rubricIds = rubricIds,
        contactInfos = contactInfos
    )
}

fun FavouriteItem.toRoutePreviewParams(): RoutePreviewParams {
    return RoutePreviewParams(
        name = title,
        additionalInfo = subtitle,
        coordinates = coordinates,
    )
}
