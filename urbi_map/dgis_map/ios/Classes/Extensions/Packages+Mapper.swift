//
//  Packages+Mapper.swift
//  dgis_map
//
//  Created by Arina Kharlamova on 22.11.2023.
//

import Foundation
import DGis

extension Package {
    func toMessage() -> PackageMessage {
        PackageMessage.make(
            withId: self.id,
            info: self.info.toMessage()
        )
    }
}

extension PackageInfo {
    func toMessage() ->  PackageInfoMessage{
        PackageInfoMessage.make(
            withName: self.name,
            installed: NSNumber(value: self.installed),
            incomplete: NSNumber(value: self.incomplete),
            preinstalled: NSNumber(value: self.preinstalled),
            compatible: NSNumber(value: self.compatible),
            hasUpdate: NSNumber(value: self.hasUpdate),
            updateStatus: self.updateStatus.toMessage()
        )
    }
}

extension PackageUpdateStatus {
    func toMessage() -> PackageUpdateStatusMessage {
        switch self {
        case .inProgress:
            return .inProgress
        case .notAvailable:
            return .notAvailable
        case .paused:
            return .paused
        }
    }
}

