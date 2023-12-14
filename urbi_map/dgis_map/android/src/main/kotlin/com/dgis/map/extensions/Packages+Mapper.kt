package com.dgis.map.extensions

import com.dgis.map.map_api.Messages.PackageInfoMessage
import com.dgis.map.map_api.Messages.PackageMessage
import com.dgis.map.map_api.Messages.PackageUpdateStatusMessage
import ru.dgis.sdk.update.Package
import ru.dgis.sdk.update.PackageInfo
import ru.dgis.sdk.update.PackageUpdateStatus

fun Package.toMessage(): PackageMessage {
    return PackageMessage.Builder()
            .setId(id)
            .setInfo(info.toMessage())
            .build()
}

fun PackageInfo.toMessage(): PackageInfoMessage {
    return PackageInfoMessage.Builder()
            .setName(name)
            .setInstalled(installed)
            .setIncomplete(incomplete)
            .setPreinstalled(preinstalled)
            .setCompatible(compatible)
            .setHasUpdate(hasUpdate)
            .setUpdateStatus(updateStatus.toMessage())
            .build()
}

fun PackageUpdateStatus.toMessage(): PackageUpdateStatusMessage = when (this) {
    PackageUpdateStatus.IN_PROGRESS -> PackageUpdateStatusMessage.IN_PROGRESS
    PackageUpdateStatus.PAUSED -> PackageUpdateStatusMessage.PAUSED
    PackageUpdateStatus.NOT_AVAILABLE -> PackageUpdateStatusMessage.NOT_AVAILABLE
}
