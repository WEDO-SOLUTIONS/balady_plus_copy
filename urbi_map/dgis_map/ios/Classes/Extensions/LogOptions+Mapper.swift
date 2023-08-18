import Foundation
import DGis

extension LogOptionsMessage {
    var logOptions: LogOptions {
        LogOptions(
            osLogLevel: self.systemLevel.logLevel,
            customLogLevel: self.customLevel.logLevel,
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
            return .fault
        case .off:
            return .disabled
        }
    }
}

fileprivate extension String {
    var customSink: LogSink {
        Logger(logFileName: self)
    }
}
