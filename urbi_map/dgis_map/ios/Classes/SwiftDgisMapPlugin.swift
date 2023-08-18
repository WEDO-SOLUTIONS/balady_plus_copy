import Flutter
import UIKit
import DGis

public class SwiftDgisMapPlugin: NSObject, FlutterPlugin {
    private static let flutterViewId = "com.dgis.map_view"
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let factory = DgisMapViewFactory(registrar: registrar)

        registrar.register(factory, withId: self.flutterViewId)
    }
}
