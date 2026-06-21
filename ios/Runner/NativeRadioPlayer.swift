import AVFoundation
import Flutter
import Foundation
import MediaPlayer
import UIKit

final class NativeRadioPlayer: NSObject {

    static let channelName = "com.balady.native_radio"

    private let channel: FlutterMethodChannel
    private var player: AVPlayer?
    private var playerItem: AVPlayerItem?
    private var statusObservation: NSKeyValueObservation?
    private var rateObservation: NSKeyValueObservation?
    private var fadeTimer: Timer?
    private var healthCheckTimer: Timer?
    private var stallSeconds = 0

    private var currentURL: URL?
    private var currentTitle: String = "Live Radio"
    private var currentArtist: String = ""

    private var isExpectedToPlay = false
    private var lastSentState: String = ""

    // MARK: - Init

    init(messenger: FlutterBinaryMessenger) {
        channel = FlutterMethodChannel(
            name: NativeRadioPlayer.channelName,
            binaryMessenger: messenger
        )
        super.init()
        // IMPORTANT: do NOT use `.mixWithOthers` here.
        // iOS hides Now Playing Info (lock screen / Control Center / CarPlay)
        // and ignores MPRemoteCommandCenter targets whenever the audio session
        // is mixable, because the app is treated as secondary/ambient audio.
        // For MBC we want the standard "media player" UI, so the session must
        // be exclusive `.playback`. Navigation-voice coexistence is handled
        // via our explicit volume-fade duck (`duckForVoice` / `restoreAfterVoice`).
        try? AVAudioSession.sharedInstance().setCategory(
            .playback,
            mode: .default,
            options: [.allowBluetoothA2DP, .allowAirPlay]
        )
        bindChannel()
        observeRouteChange()
        setupRemoteCommands()
        observeVoiceEvents()
    }

    // MARK: - Flutter ↔ Native

    private func bindChannel() {
        channel.setMethodCallHandler { [weak self] call, result in
            guard let self else {
                result(FlutterError(code: "DEALLOCATED", message: nil, details: nil))
                return
            }
            switch call.method {
            case "play":
                guard
                    let args = call.arguments as? [String: Any],
                    let urlStr = args["url"] as? String,
                    let url = URL(string: urlStr)
                else {
                    result(FlutterError(code: "INVALID_ARGS", message: "Missing url", details: nil))
                    return
                }
                self.currentTitle = args["title"] as? String ?? "Live Radio"
                self.currentArtist = args["artist"] as? String ?? ""
                self.startPlayback(url: url)
                result(nil)
            case "pause":
                self.pause()
                result(nil)
            case "resume":
                self.resume()
                result(nil)
            case "stop":
                self.stop()
                result(nil)
            case "getState":
                result(self.stateString)
            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }

    // MARK: - Controls

    func startPlayback(url: URL) {
        NSLog("NativeRadioPlayer ▶ play \(url)")
        isExpectedToPlay = true
        stallSeconds = 0
        currentURL = url
        activateSession()
        // Required for MPRemoteCommandCenter targets to be delivered to the
        // app on some iOS versions / configurations. Safe to call repeatedly.
        DispatchQueue.main.async {
            UIApplication.shared.beginReceivingRemoteControlEvents()
        }
        buildPlayer(url: url)
        player?.volume = 1.0
        player?.play()
        updateLockScreen()
        startHealthCheck()
    }

    func pause() {
        NSLog("NativeRadioPlayer ⏸ pause")
        isExpectedToPlay = false
        stallSeconds = 0
        stopHealthCheck()
        player?.pause()
        sendState()
    }

    func resume() {
        NSLog("NativeRadioPlayer ▶ resume")
        guard let url = currentURL else { return }
        startPlayback(url: url)
    }

    func stop() {
        NSLog("NativeRadioPlayer ■ stop")
        isExpectedToPlay = false
        stallSeconds = 0
        fadeTimer?.invalidate(); fadeTimer = nil
        stopHealthCheck()
        teardownPlayer()
        currentURL = nil
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
        sendState()
    }

    // MARK: - Audio session

    private func activateSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(
                .playback,
                mode: .default,
                options: [.allowBluetoothA2DP, .allowAirPlay]
            )
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            NSLog("NativeRadioPlayer ⚠️ session activate failed: \(error)")
        }
    }

    // MARK: - AVPlayer lifecycle

    private func buildPlayer(url: URL) {
        teardownPlayer()

        let item = AVPlayerItem(url: url)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onPlaybackStalled(_:)),
            name: .AVPlayerItemPlaybackStalled,
            object: item
        )

        statusObservation = item.observe(\.status, options: [.new]) { [weak self] item, _ in
            DispatchQueue.main.async { self?.onItemStatusChanged(item) }
        }
        playerItem = item

        if let p = player {
            p.replaceCurrentItem(with: item)
        } else {
            let p = AVPlayer(playerItem: item)
            p.automaticallyWaitsToMinimizeStalling = true
            rateObservation = p.observe(\.timeControlStatus, options: [.new]) { [weak self] _, _ in
                DispatchQueue.main.async {
                    guard let self else { return }
                    if self.player?.timeControlStatus == .paused, self.isExpectedToPlay {
                        self.player?.play()
                    }
                    if self.player?.timeControlStatus == .playing {
                        self.stallSeconds = 0
                    }
                    self.sendState()
                }
            }
            player = p
        }
    }

    private func teardownPlayer() {
        statusObservation?.invalidate()
        statusObservation = nil
        player?.pause()
        player?.replaceCurrentItem(with: nil)
        playerItem = nil
    }

    @objc private func onPlaybackStalled(_ note: Notification) {
        guard let item = note.object as? AVPlayerItem else { return }
        let loaded = item.loadedTimeRanges.first.map {
            CMTimeGetSeconds($0.timeRangeValue.duration)
        } ?? 0
        NSLog("NativeRadioPlayer 🛑 playback stalled — buffered=\(String(format: "%.1f", loaded))s error=\(String(describing: item.error))")
    }

    private func onItemStatusChanged(_ item: AVPlayerItem) {
        if item.status == .failed {
            NSLog("NativeRadioPlayer ❌ item failed: \(String(describing: item.error))")
            sendState("error")
        } else {
            sendState()
        }
    }

    // MARK: - Health check (genuine network failure only)

    private func startHealthCheck() {
        stopHealthCheck()
        healthCheckTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.performHealthCheck()
        }
    }

    private func stopHealthCheck() {
        healthCheckTimer?.invalidate()
        healthCheckTimer = nil
    }

    private func performHealthCheck() {
        guard isExpectedToPlay else { stallSeconds = 0; return }
        guard let p = player else {
            if let url = currentURL { startPlayback(url: url) }
            return
        }
        if let item = p.currentItem, item.status == .failed {
            NSLog("NativeRadioPlayer 🔄 item failed — restart")
            if let url = currentURL { startPlayback(url: url) }
            return
        }
        if p.timeControlStatus != .paused { stallSeconds = 0; return }
        stallSeconds += 1
        NSLog("NativeRadioPlayer 🩺 stall \(stallSeconds)s")
        guard stallSeconds >= 10 else { return }
        stallSeconds = 0
        NSLog("NativeRadioPlayer 🔄 health-check rebuild (stalled 10 s)")
        if p.currentItem == nil, let url = currentURL {
            buildPlayer(url: url)
            p.play()
        }
    }

    // MARK: - Voice ducking

    private func observeVoiceEvents() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(duckForVoice),
            name: .navigationVoiceStarted, object: nil)
        NotificationCenter.default.addObserver(
            self, selector: #selector(restoreAfterVoice),
            name: .navigationVoiceEnded, object: nil)
    }

    @objc private func duckForVoice() {
        fadeVolume(to: 0.2, duration: 0.2)
    }

    @objc private func restoreAfterVoice() {
        fadeVolume(to: 1.0, duration: 0.5)
    }

    private func fadeVolume(to target: Float, duration: TimeInterval) {
        fadeTimer?.invalidate()
        guard let p = player else { player?.volume = target; return }
        let steps = 20
        let stepInterval = duration / Double(steps)
        let start = p.volume
        var step = 0
        fadeTimer = Timer.scheduledTimer(withTimeInterval: stepInterval, repeats: true) { [weak self] t in
            step += 1
            let progress = Float(step) / Float(steps)
            self?.player?.volume = start + (target - start) * progress
            if step >= steps {
                self?.player?.volume = target
                t.invalidate()
                self?.fadeTimer = nil
            }
        }
    }

    // MARK: - Route change

    private func observeRouteChange() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleRouteChange(_:)),
            name: AVAudioSession.routeChangeNotification,
            object: AVAudioSession.sharedInstance()
        )
    }

    @objc private func handleRouteChange(_ note: Notification) {
        guard
            let info = note.userInfo,
            let rawReason = info[AVAudioSessionRouteChangeReasonKey] as? UInt,
            let reason = AVAudioSession.RouteChangeReason(rawValue: rawReason)
        else { return }
        if reason == .oldDeviceUnavailable {
            isExpectedToPlay = false
            player?.pause()
            sendState()
        }
    }

    // MARK: - State → Flutter

    private var stateString: String {
        guard let p = player else { return "stopped" }
        if let item = p.currentItem, item.status == .failed { return "error" }
        switch p.timeControlStatus {
        case .playing:                          return "playing"
        case .waitingToPlayAtSpecifiedRate:     return isExpectedToPlay ? "loading" : "paused"
        case .paused:                           return isExpectedToPlay ? "loading" : "paused"
        @unknown default:                       return "stopped"
        }
    }

    private func sendState(_ override: String? = nil) {
        let state = override ?? stateString
        // Keep the lock-screen play/pause indicator in sync with the real state.
        updateLockScreen()
        guard state != lastSentState || override != nil else { return }
        lastSentState = state
        NSLog("NativeRadioPlayer 📡 → Flutter state=\(state)")
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.channel.invokeMethod("onStateChanged", arguments: ["state": state]) { _ in }
        }
    }

    // MARK: - Lock screen

    private func updateLockScreen() {
        let isPlaying = (player?.timeControlStatus == .playing)
        // NOTE: do NOT set MPNowPlayingInfoPropertyIsLiveStream = true.
        // When that flag is true, iOS renders a STOP button on the lock screen
        // / Control Center instead of the usual PLAY / PAUSE toggle (because
        // pausing a live stream is meaningless to the system). For MBC we
        // want the standard pause/resume controls, so the item is presented
        // as a regular audio item.
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [
            MPMediaItemPropertyTitle: currentTitle,
            MPMediaItemPropertyArtist: currentArtist,
            MPNowPlayingInfoPropertyPlaybackRate: isPlaying ? 1.0 : 0.0,
            MPNowPlayingInfoPropertyMediaType: MPNowPlayingInfoMediaType.audio.rawValue,
        ]
    }

    private func setupRemoteCommands() {
        let cc = MPRemoteCommandCenter.shared()

        // Disable transport commands we don't support so iOS doesn't render
        // dead next/previous/seek buttons.
        cc.nextTrackCommand.isEnabled = false
        cc.previousTrackCommand.isEnabled = false
        cc.skipForwardCommand.isEnabled = false
        cc.skipBackwardCommand.isEnabled = false
        cc.seekForwardCommand.isEnabled = false
        cc.seekBackwardCommand.isEnabled = false
        cc.changePlaybackPositionCommand.isEnabled = false

        cc.playCommand.isEnabled = true
        cc.pauseCommand.isEnabled = true
        // Disable stopCommand: with IsLiveStream = false we now get the
        // standard play/pause toggle, and exposing Stop alongside it just
        // duplicates functionality and confuses the lock-screen layout. The
        // user can fully terminate playback from inside the app.
        cc.stopCommand.isEnabled = false
        cc.togglePlayPauseCommand.isEnabled = true

        cc.playCommand.addTarget  { [weak self] _ in self?.resume(); return .success }
        cc.pauseCommand.addTarget { [weak self] _ in self?.pause();  return .success }
        cc.stopCommand.addTarget  { [weak self] _ in self?.stop();   return .success }
        cc.togglePlayPauseCommand.addTarget { [weak self] _ in
            guard let self else { return .commandFailed }
            if self.isExpectedToPlay { self.pause() } else { self.resume() }
            return .success
        }
    }
}
