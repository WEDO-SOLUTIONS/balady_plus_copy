import Foundation
import DGis

class DgisMapViewFactory: NSObject, FlutterPlatformViewFactory {
    private let sdk: DGis.Container
    private let registrar: FlutterPluginRegistrar

    init(dgisSdk sdk: DGis.Container, registrar: FlutterPluginRegistrar) {
        self.registrar = registrar
        self.sdk = sdk
        
        super.init()
    }

    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return DgisMapView(
            dgisSdk: self.sdk,
            frame: frame,
            viewIdentifier: viewId,
            arguments: args,
            registrar: registrar
        )
    }
}
