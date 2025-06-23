package com.dgis.map.android_auto

import ru.dgis.sdk.directory.DirectoryObject

fun DirectoryObject.makeAddressString(): String {
    val region = address?.drillDown?.firstOrNull { it.type == "region" }
    val districtArea =
        address?.drillDown?.firstOrNull { it.type == "district_area" }
    val district = address?.drillDown?.firstOrNull { it.type == "district" }
    val street =
        address?.components?.firstOrNull { it.asStreetAddress != null }?.asStreetAddress?.street
    return listOfNotNull(
        street, district?.name, districtArea?.name, region?.name
    ).joinToString()
}
