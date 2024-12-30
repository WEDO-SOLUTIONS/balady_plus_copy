import Foundation
import DGis

extension LogOptionsMessage {
    var logOptions: LogOptions {
        LogOptions(
            systemLevel: self.systemLevel.logLevel,
            customLevel: self.customLevel.logLevel,
            customSink: self.customSink?.customSink
        )
    }
}

fileprivate extension LogLevelMessage {
    var logLevel: LogLevel {
        switch self {
        case .verbose:
            return .verbose
        case .info:
            return .info
        case .warning:
            return .warning
        case .error:
            return .error
        case .fatal:
            return .fatal
        case .off:
            return .off
        @unknown default:
            return .off
        }
    }
}

fileprivate extension String {
    var customSink: LogSink {
        Logger(logFileName: self)
    }
}
