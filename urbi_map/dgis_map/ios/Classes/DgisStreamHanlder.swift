import Foundation
import Flutter

class DgisStreamHandler: NSObject, FlutterStreamHandler {
    private var eventSink: FlutterEventSink?
    
    private let completion: () -> Void

    init(viewId: Int64, messenger: FlutterBinaryMessenger, completion: @escaping () -> Void) {
        self.completion = completion
        
        super.init()

        let eventChannel = FlutterEventChannel(
            name: "com.dgis.map_view_events_\(viewId)",
            binaryMessenger: messenger)
        eventChannel.setStreamHandler(self)
    }
    
    func success(_ value: Any?) {
        eventSink?(value)
    }
    
    func error(
        code: String,
        message: String? = nil,
        details: Any? = nil
    ) {
        eventSink?(FlutterError(code: code, message: message, details: details))
    }
    
    func onListen(
        withArguments arguments: Any?,
        eventSink events: @escaping FlutterEventSink
    ) -> FlutterError? {
        self.eventSink = events
        completion()

        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil

        return nil
    }
}
