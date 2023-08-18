import Foundation
import DGis

class DgisMapViewFactory: NSObject, FlutterPlatformViewFactory {
    private let registrar: FlutterPluginRegistrar

    init(registrar: FlutterPluginRegistrar) {
        self.registrar = registrar
        
        super.init()
    }
    
    private func initializeDGis(logOptions: LogOptions?) -> DGis.Container {
        let vendorConfigFile = Bundle.main.path(forResource: "vendor-config", ofType: "jsonx").map { File(path: $0) }
        
        return Container(
            logOptions: logOptions ?? LogOptions(
                osLogLevel: .warning,
                customLogLevel: .warning,
                customSink: nil
            ),
            vendorConfigFile: vendorConfigFile
        )
    }

    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        let logOptions: LogOptionsMessage? = args as? LogOptionsMessage
        let sdk = initializeDGis(logOptions: logOptions?.logOptions)
        
        return DgisMapView(
            dgisSdk: sdk,
            frame: frame,
            viewIdentifier: viewId,
            arguments: args,
            registrar: registrar
        )
    }
    
    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return MapApiGetCodec()
    }
}
