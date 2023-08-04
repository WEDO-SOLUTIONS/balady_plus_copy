import Foundation
import DGis

extension SimpleClusterObject {
    func toMap() -> [String: Any?] {
        return [
            "position": [
                "latitude": self.position.latitude.value,
                "longitude": self.position.longitude.value,
                "elevation": self.position.elevation.value
            ] as [String : Any],
            "objectCount": self.objectCount,
            "anchor": [
                "x": self.anchor.x,
                "y": self.anchor.y
            ],
            "iconOpacity": self.iconOpacity.value,
            "text": self.text,
            "textStyle": self.textStyle.toMap(),
            "iconWidth": self.iconWidth.value,
            "iconMapDirection": self.iconMapDirection?.value
        ]
    }
}
