//
//  Voice+Package.swift
//  dgis_map
//
//  Created by Аят Алиев on 15/8/24.
//

import Foundation
import DGis

extension Voice {
    func toVoiceMessage() -> VoiceMessage {
        return VoiceMessage.make(
            withLanguage: self.language,
            packageMessage: self.toMessage()
        )
    }
}
