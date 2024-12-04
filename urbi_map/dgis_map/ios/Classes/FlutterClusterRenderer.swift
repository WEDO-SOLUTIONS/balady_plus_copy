import Foundation
import DGis

class FlutterClusterRenderer: SimpleClusterRenderer {
    let api: FlutterMapApi
    let registrar: FlutterPluginRegistrar
    let imageFactory: IImageFactory
    let manager: MapObjectManagerMessage
    
    init(api: FlutterMapApi, registrar: FlutterPluginRegistrar, imageFactory: IImageFactory, manager: MapObjectManagerMessage) {
        self.api = api
        self.registrar = registrar
        self.imageFactory = imageFactory
        self.manager = manager
    }
    
    private var iconCache: Dictionary<String, Image> = [:]
    
    func renderCluster(cluster: DGis.SimpleClusterObject) -> DGis.SimpleClusterOptions {
        let semaphore = DispatchSemaphore(value: 0)
        var message: SimpleClusterOptionsMessage? = nil
        var options: SimpleClusterOptions? = nil
//        
//        api.renderCluster(
//            manager: manager,
//            objectCount: Int64(Int(truncating: NSNumber(value: cluster.objectCount))), completion: @escaping Result<SimpleClusterOptionsMessage, PigeonError>
//        )
//        
        
        semaphore.wait()
        
        var markerImage: Image? = nil
        if let icon = message!.icon?.svgPath {
            if let cachedIcon = iconCache[icon] {
                markerImage = cachedIcon
            } else {
                let assetKey = registrar.lookupKey(forAsset: icon)
                
                guard let assetPath = Bundle.main.path(forResource: assetKey, ofType: nil),
                      let url = URL(string: "file://\(assetPath)"),
                      let data = try? Data(contentsOf: url) else {
                    assert(false, "Oops we fail")
                    return options!
                }
                
                let image = imageFactory.make(svgData: data, size: .zero)
                markerImage = image
                iconCache[icon] = image
            }
        }
        
        options = SimpleClusterOptions(
            icon: markerImage,
            iconMapDirection: message!.icon?.iconMapDirection.map {
                MapDirection(value: $0.degree)
            },
            anchor: message!.anchor.map {
                Anchor(x: Float($0.x), y: Float($0.y))
            } ?? Anchor(x: 0.5, y: 0.5),
            text: message!.text,
            textStyle: message!.textStyle?.textStyle,
            iconWidth: (message!.icon?.width).map {
                LogicalPixel(value: Float($0))
            } ?? LogicalPixel(value: 0),
            userData: manager,
            animatedAppearance: false
        )
        
        return options!
    }
}
