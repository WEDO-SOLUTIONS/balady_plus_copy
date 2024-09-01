import Foundation
import DGis

final class Logger: LogSink {
    private enum Constants {
        static let logMessageFormat: String = "yyyy-MM-dd HH:mm:ss.SSSZ"
        static let logFileDateFormat: String = "yyyy-MM-dd-HH-mm-ss-sss"
    }

    let formatter: DateFormatter
    var logHandle: FileHandle? = nil

    init(logFileName: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.logFileDateFormat
        if let url = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first {
            let logFileURL = url.appendingPathComponent("\(logFileName)-\(formatter.string(from: Date())).log")
            if !FileManager.default.fileExists(atPath: url.path) {
                try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
            }
            let result = FileManager.default.createFile(
                atPath: logFileURL.path,
                contents: nil,
                attributes: nil
            )
            self.logHandle = try? FileHandle(forWritingTo: logFileURL)
        }
        self.formatter = formatter
    }
    
    func write(message: DGis.LogMessage) {
        let logLine = "\(formatter.string(from: Date())) \(self.makeLevelString(message.level)) \(message.file):\(message.line) - \(message.text)\n"
        logHandle?.write(logLine.data(using: .utf8)!)
    }
    
    private func makeLevelString(_ level: LogLevel) -> String {
        switch level {
        case .verbose:
            return "VERBOSE"
        case .info:
            return "INFO"
        case .warning:
            return "WARNING"
        case .error:
            return "ERROR"
        case .fatal:
            return "FATAL"
        case .off:
            return ""
        }
    }
}
