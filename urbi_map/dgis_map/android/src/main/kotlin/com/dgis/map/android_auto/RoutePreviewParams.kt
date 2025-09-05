package com.dgis.map.android_auto

import com.dgis.map.map_api.FavouriteItemMessage
import com.dgis.map.map_api.GeoPointMessage
import ru.dgis.sdk.DgisObjectId
import ru.dgis.sdk.directory.ContactInfo
import ru.dgis.sdk.directory.DirectoryObject
import ru.dgis.sdk.directory.RubricId

data class RoutePreviewParams(
    val name: String,
    val additionalInfo: String,
    val coordinates: GeoPointMessage?,
    val id: DgisObjectId? = null,
    val rubricIds: List<RubricId>? = null,
    val contactInfos: List<ContactInfo>? = null,
)

fun DirectoryObject.toRoutePreviewParams(): RoutePreviewParams {
    return RoutePreviewParams(
        name = title,
        additionalInfo = makeAddressString(),
        coordinates = if (markerPosition != null) GeoPointMessage(
            markerPosition!!.latitude.value,
            markerPosition!!.longitude.value,
        ) else null,
        id = id,
        rubricIds = rubricIds,
        contactInfos = contactInfos
    )
}


fun FavouriteItemMessage.toRoutePreviewParams(): RoutePreviewParams {
    return RoutePreviewParams(
        name = title,
        additionalInfo = subtitle,
        coordinates = coordinates,
    )
}
