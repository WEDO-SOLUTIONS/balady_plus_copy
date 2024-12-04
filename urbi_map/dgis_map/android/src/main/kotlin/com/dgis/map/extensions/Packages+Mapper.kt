package com.dgis.map.extensions

import com.dgis.map.map_api.PackageInfoMessage
import com.dgis.map.map_api.PackageMessage
import com.dgis.map.map_api.PackageUpdateStatusMessage
import ru.dgis.sdk.update.Package
import ru.dgis.sdk.update.PackageInfo
import ru.dgis.sdk.update.PackageUpdateStatus
fun Package.toMessage(): PackageMessage {
    return PackageMessage(
        id = id,
        info = info.toMessage()
    )
}

fun PackageInfo.toMessage(): PackageInfoMessage {
    return PackageInfoMessage(
        name = name,
        installed = installed,
        incomplete = incomplete,
        preinstalled = preinstalled,
        compatible = compatible,
        hasUpdate = hasUpdate,
        updateStatus = updateStatus.toMessage()
    )
}

fun PackageUpdateStatus.toMessage(): PackageUpdateStatusMessage = when (this) {
    PackageUpdateStatus.IN_PROGRESS -> PackageUpdateStatusMessage.IN_PROGRESS
    PackageUpdateStatus.PAUSED -> PackageUpdateStatusMessage.PAUSED
    PackageUpdateStatus.NOT_AVAILABLE -> PackageUpdateStatusMessage.NOT_AVAILABLE
}