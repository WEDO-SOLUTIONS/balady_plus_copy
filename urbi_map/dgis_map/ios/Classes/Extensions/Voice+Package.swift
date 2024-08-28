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
