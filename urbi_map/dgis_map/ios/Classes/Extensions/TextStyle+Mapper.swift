import Foundation
import DGis

extension TextPlacementMessage {
    var textPlacement: TextPlacement {
        switch self {
        case .noLabel:
            return .noLabel
        case .bottomCenter:
            return .bottomCenter
        case .bottomRight:
            return .bottomRight
        case .bottomLeft:
            return .bottomLeft
        case .circleBottomRight:
            return .circleBottomRight
        case .rightBottom:
            return .rightBottom
        case .rightCenter:
            return .rightCenter
        case .rightTop:
            return .rightTop
        case .circleTopRight:
            return .circleTopRight
        case .topCenter:
            return .topCenter
        case .topRight:
            return .topRight
        case .topLeft:
            return .topLeft
        case .circleTopLeft:
            return .circleTopLeft
        case .leftTop:
            return .leftTop
        case .leftCenter:
            return .leftCenter
        case .leftBottom:
            return .leftBottom
        case .circleBottomLeft:
            return .circleBottomLeft
        case .centerCenter:
            return .centerCenter
        @unknown default:
            return .noLabel
        }
    }
}

extension TextPlacement {
    func toMessage() -> TextPlacementMessage {
        switch self {
        case .noLabel:
            return .noLabel
        case .bottomCenter:
            return .bottomCenter
        case .bottomRight:
            return .bottomRight
        case .bottomLeft:
            return .bottomLeft
        case .circleBottomRight:
            return .circleBottomRight
        case .rightBottom:
            return .rightBottom
        case .rightCenter:
            return .rightCenter
        case .rightTop:
            return .rightTop
        case .circleTopRight:
            return .circleTopRight
        case .topCenter:
            return .topCenter
        case .topRight:
            return .topRight
        case .topLeft:
            return .topLeft
        case .circleTopLeft:
            return .circleTopLeft
        case .leftTop:
            return .leftTop
        case .leftCenter:
            return .leftCenter
        case .leftBottom:
            return .leftBottom
        case .circleBottomLeft:
            return .circleBottomLeft
        case .centerCenter:
            return .centerCenter
        @unknown default:
            return .noLabel
        }
    }
}

extension MarkerTextStyleMessage {
    var textStyle: TextStyle {
        return TextStyle(
            fontSize: self.fontSize.map {
                LogicalPixel(value: $0.floatValue)
            } ?? LogicalPixel(value: 8),
            color: self.color.map {
                return Color(argb: UInt32($0.intValue))
            } ?? Color(),
            strokeWidth: self.strokeWidth.map {
                LogicalPixel(value: $0.floatValue)
            } ?? LogicalPixel(value: 0.3499999940395355),
            strokeColor: self.strokeColor.map {
                Color(argb: UInt32($0.intValue))
            } ?? Color(argb: 4294967295),
            textPlacement: self.textPlacement?.placement.textPlacement ?? .bottomCenter,
            textOffset: self.textOffset.map {
                LogicalPixel(value: $0.floatValue)
            } ?? LogicalPixel(value: 0),
            fontName: self.fontName
        )
    }
}

extension TextStyle {
    func toMessage() -> MarkerTextStyleMessage {
        return MarkerTextStyleMessage.make(
            withFontSize: NSNumber(value: self.fontSize.value),
            color: NSNumber(value: self.color.argb),
            strokeWidth: NSNumber(value: self.strokeWidth.value),
            strokeColor: NSNumber(value: self.strokeColor.argb),
            textPlacement: MarkerTextPlacementMessage.make(
                withPlacement: self.textPlacement.toMessage()
            ),
            textOffset: NSNumber(value: self.textOffset.value),
            fontName: self.fontName
        )
    }
}
