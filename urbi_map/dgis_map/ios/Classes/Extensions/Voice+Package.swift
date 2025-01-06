import Foundation
import DGis

extension Voice {
    func toVoiceMessage() -> VoiceMessage {
        return VoiceMessage(
            language: self.language,
            packageMessage: self.toMessage()
        )
    }
}
