import Foundation
import DGis

extension SimpleClusterObject {
    func toMessage() -> SimpleClusterObjectMessage {
        SimpleClusterObjectMessage.make(
            withPosition: GeoPointWithElevationMessage.make(
                withLatitude: NSNumber(value: 0.0),
                longitude: NSNumber(value: 0.0),
                elevation: NSNumber(value: 0.0)
            ), // self.position.toMessage(),
            objectCount: NSNumber(value: self.objectCount),
            anchor: MarkerAnchorMessage.makeWith(
                x: NSNumber(value: 0.0), // NSNumber(value: self.anchor.x),
                y: NSNumber(value: 0.0) //NSNumber(value: self.anchor.y)
            ),
            iconOpacity: NSNumber(value: 0.0), // NSNumber(value: self.iconOpacity.value),
            text: "", //self.text,
            textStyle: nil, // self.textStyle.toMessage(),
            iconWidth: NSNumber(value: 0.0), // NSNumber(value: self.iconWidth.value),
            iconMapDirection: MarkerAzimuthMessage.make(withDegree: NSNumber(value: 0.0)) /* self.iconMapDirection.map {
                MarkerAzimuthMessage.make(withDegree: NSNumber(value: $0.value))
            }*/
        )
    }
}
