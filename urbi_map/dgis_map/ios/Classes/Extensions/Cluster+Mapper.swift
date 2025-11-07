import Foundation
import DGis

extension SimpleClusterObject {
    func toMap(id: String) -> [String: Any?] {
        return [
            "id": id,
            "position": [
                "latitude": self.position.latitude.value,
                "longitude": self.position.longitude.value,
                "elevation": self.position.elevation.value
            ] as [String : Any],
            "objectCount": self.objectCount,
            "objects": self.objects.compactMap {
                if let markerId = $0.userData as? MarkerId {
                    return markerId.id
                }
                
                return nil
            },
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
