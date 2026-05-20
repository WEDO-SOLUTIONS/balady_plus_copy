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
    private var isMbcActive: Bool = false

    init(messenger: FlutterBinaryMessenger) {
        self.channel = FlutterMethodChannel(
            name: "com.balady.audio_coordination",
            binaryMessenger: messenger
        )
        registerFlutterToNativeHandlers()
        startObserving()
    }

    private func registerFlutterToNativeHandlers() {
        // Flutter calls into this channel to indicate MBC playback state.
        // If we don't handle these calls, Flutter will throw MissingPluginException.
        channel.setMethodCallHandler { [weak self] call, result in
            guard let self else {
                result(FlutterError(
                    code: "AudioCoordinationManagerDeallocated",
                    message: "AudioCoordinationManager was deallocated",
                    details: nil
                ))
                return
            }

            switch call.method {
            case "notifyMBCActive":
                self.isMbcActive = true
                result(nil)
            case "notifyMBCInactive":
                self.isMbcActive = false
                result(nil)
            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }

    private func startObserving() {
        let center = NotificationCenter.default

        // Primary signal: system wants secondary audio silenced (navigation voice start/end).
        center.addObserver(
            self,
            selector: #selector(handleSilenceSecondaryHint(_:)),
            name: AVAudioSession.silenceSecondaryAudioHintNotification,
            object: AVAudioSession.sharedInstance()
        )

        // Fallback: standard interruption (phone call, Siri, same-process session fight).
        center.addObserver(
            self,
            selector: #selector(handleInterruption(_:)),
            name: AVAudioSession.interruptionNotification,
            object: AVAudioSession.sharedInstance()
        )
    }

    @objc private func handleSilenceSecondaryHint(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let rawType = userInfo[AVAudioSessionSilenceSecondaryAudioHintTypeKey] as? UInt,
              let type = AVAudioSession.SilenceSecondaryAudioHintType(rawValue: rawType)
        else { return }

        switch type {
        case .begin:
            DispatchQueue.main.async {
                self.channel.invokeMethod("navigationVoiceStarted", arguments: nil)
            }
        case .end:
            DispatchQueue.main.async {
                self.channel.invokeMethod("navigationVoiceEnded", arguments: nil)
            }
        @unknown default:
            break
        }
    }

    @objc private func handleInterruption(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let rawType = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
              let type = AVAudioSession.InterruptionType(rawValue: rawType)
        else { return }

        switch type {
        case .began:
            DispatchQueue.main.async {
                self.channel.invokeMethod("navigationVoiceStarted", arguments: nil)
            }
        case .ended:
            DispatchQueue.main.async {
                self.channel.invokeMethod("navigationVoiceEnded", arguments: nil)
            }
        @unknown default:
            break
        }
    }
}

