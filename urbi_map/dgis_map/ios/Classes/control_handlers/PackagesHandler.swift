import Foundation
import DGis

class PackagesHandler {
    private class Events {
        static let packageProgressEvent = "packageProgressEvent"
        static let packageInfoChangedEvent = "packageInfoChangedEvent"
    }
    
    enum InstallTask {
        case voice(String)
        case package(String)
    }
    
    private let sdk: Context
    private let eventChannel: DgisStreamHandler
    
    private let packageManager: PackageManager
    private let voiceManager: VoiceManager
    
    private var cancelable: Array<Cancellable> = []
    private var installTasks: Array<InstallTask> = []
    
    init(sdk: Context, eventChannel: DgisStreamHandler) {
        self.sdk = sdk
        self.eventChannel = eventChannel
        self.packageManager = PackageManager.instance(context: sdk)
        self.voiceManager = VoiceManager.instance(context: sdk)
        
        cancelable.append(
            self.packageManager.packagesChannel.sinkOnMainThread(checkInstallTasks)
        )
        cancelable.append(
            self.voiceManager.voicesChannel.sinkOnMainThread(checkInstallTasks)
        )
        
        self.packageManager.autoupdateEnabled = true
        self.packageManager.checkForUpdates()
    }
    
    func noop(_: Result<Void, any Error>) -> Void {}
    
    func checkInstallTasks(_ packages: [Package]) {
        let tasks = self.installTasks
        self.installTasks.removeAll()
        
        for task in tasks {
            switch task {
            case .package(let id):
                self.installPackage(id, completion: noop)
            case .voice(let id):
                self.installVoice(id, completion: noop)
            }
        }
    }
    
    func mapStatus(_ status: PackageUpdateStatus) -> String {
        switch status {
        case .notAvailable:
            return "notAvailable"
        case .inProgress:
            return "inProgress"
        case .paused:
            return "paused"
        }
    }
    
    func mapInfo(info: PackageInfo) -> [String: Any] {
        return [
            "name": info.name,
            "installed": info.installed,
            "incomplete": info.incomplete,
            "preinstalled": info.preinstalled,
            "compatible": info.compatible,
            "hasUpdate": info.hasUpdate,
            "updateStatus": mapStatus(info.updateStatus),
        ]
    }
    
    func cancel() {
        cancelable.forEach { $0.cancel() }
        cancelable.removeAll()
    }
    
    func listPackages(completion: @escaping (Result<[PackageMessage], any Error>) -> Void) {
        completion(Result.success(packageManager.packages.map { $0.toMessage() }))
    }
    
    func installPackage(_ id: String, completion: @escaping (Result<Void, any Error>) -> Void) {
        if let package = packageManager.packages.first(where: { $0.id == id }) {
            cancelable.append(package.progressChannel.sinkOnMainThread { [weak self] in
                self?.eventChannel.success([
                    "event": Events.packageProgressEvent,
                    "packageId": id,
                    "progress": $0
                ])
            })
            cancelable.append(package.infoChannel.sinkOnMainThread { [weak self] in
                guard let self else { return }

                self.eventChannel.success([
                    "event": Events.packageInfoChangedEvent,
                    "id": package.id,
                    "info": self.mapInfo(info: $0)
                ])
            })
            package.install()
        } else {
            self.installTasks.append(.package(id))
        }
        completion(Result.success(()))
    }
    
    func listVoices(completion: @escaping (
        Result<[VoiceMessage], any Error>
        ) -> Void) {
        completion(
            Result.success(
            voiceManager.voices.map { $0.toVoiceMessage() }))
    }
    
    func voicePlayWelcome(_ id: String, completion: @escaping (Result<Void, any Error>) -> Void) {
        completion(Result.success(()))
    }
    
    func installVoice(_ id: String, completion: @escaping (Result<Void, any Error>) -> Void) {
        if let package = voiceManager.voices.first(where: { $0.id == id }) {
            cancelable.append(package.progressChannel.sinkOnMainThread { [weak self] in
                self?.eventChannel.success([
                    "event": Events.packageProgressEvent,
                    "packageId": id,
                    "progress": $0
                ])
            })
            cancelable.append(package.infoChannel.sinkOnMainThread { [weak self] in
                guard let self else { return }
                self.eventChannel.success([
                    "event": Events.packageInfoChangedEvent,
                    "id": package.id,
                    "info": self.mapInfo(info: $0)
                ])
            })
            package.install()
        } else {
            self.installTasks.append(.voice(id))
        }
        completion(Result.success(()))
    }
}
