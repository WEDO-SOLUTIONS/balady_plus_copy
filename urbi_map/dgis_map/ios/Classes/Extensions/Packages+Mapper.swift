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
            installed:  self.installed,
            incomplete:  self.incomplete,
            preinstalled:  self.preinstalled,
            compatible:  self.compatible,
            hasUpdate:  self.hasUpdate,
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

