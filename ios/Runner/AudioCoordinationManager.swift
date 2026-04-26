import AVFoundation
import Flutter
import Foundation

/// Bridges iOS audio coordination signals to Flutter.
///
/// Goal: pause/duck in-app audio when navigation voice prompts play,
/// and restore after the prompt finishes.
///
/// We use `AVAudioSession.silenceSecondaryAudioHintNotification` as the primary signal,
/// and fall back to interruption begin/end events.
final class AudioCoordinationManager {
    private let channel: FlutterMethodChannel

    init(messenger: FlutterBinaryMessenger) {
        self.channel = FlutterMethodChannel(
            name: "com.balady.audio_coordination",
            binaryMessenger: messenger
        )
        startObserving()
    }

    private func startObserving() {
        let center = NotificationCenter.default

        // Hint: another audio (e.g., speech) wants to silence secondary audio.
        // This is the closest system-level "voice started/finished" signal we can get.
        center.addObserver(
            self,
            selector: #selector(handleSilenceSecondaryHint(_:)),
            name: AVAudioSession.silenceSecondaryAudioHintNotification,
            object: AVAudioSession.sharedInstance()
        )

        // Fallback: interruptions (phone call, Siri, etc.)—keeps audio in a sane state.
        center.addObserver(
            self,
            selector: #selector(handleInterruption(_:)),
            name: AVAudioSession.interruptionNotification,
            object: AVAudioSession.sharedInstance()
        )
    }

    @objc private func handleSilenceSecondaryHint(_ notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let rawType = userInfo[AVAudioSessionSilenceSecondaryAudioHintTypeKey] as? UInt,
            let type = AVAudioSession.SilenceSecondaryAudioHintType(rawValue: rawType)
        else { return }

        switch type {
        case .begin:
            DispatchQueue.main.async {
                self.channel.invokeMethod("duckAudio", arguments: ["volume": 0.0])
            }
        case .end:
            DispatchQueue.main.async {
                self.channel.invokeMethod("restoreAudio", arguments: ["volume": 1.0])
            }
        @unknown default:
            break
        }
    }

    @objc private func handleInterruption(_ notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let rawType = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
            let type = AVAudioSession.InterruptionType(rawValue: rawType)
        else { return }

        switch type {
        case .began:
            DispatchQueue.main.async {
                self.channel.invokeMethod("onAudioInterrupted", arguments: nil)
            }
        case .ended:
            DispatchQueue.main.async {
                self.channel.invokeMethod("onAudioInterruptionEnded", arguments: nil)
            }
        @unknown default:
            break
        }
    }
}

