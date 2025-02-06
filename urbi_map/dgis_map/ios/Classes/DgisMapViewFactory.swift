import Foundation
import DGis

class DgisMapViewFactory: NSObject, FlutterPlatformViewFactory {
    private let registrar: FlutterPluginRegistrar

    init(registrar: FlutterPluginRegistrar) {
        self.registrar = registrar
        
        super.init()
    }

    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        let sdk = DgisMapInitializer.shared.getSdkContainer()

        return DgisMapView(
            dgisSdk: sdk,
            frame: frame,
            viewIdentifier: viewId,
            arguments: args,
            registrar: registrar
        )
    }
}
