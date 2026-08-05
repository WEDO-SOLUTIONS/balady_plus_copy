import Foundation
import DGis

class ManeuverControlModel {
    private class ManeuverEvents {
        static let maneuverEvent = "maneuverEvent"
        static let maneuverAdditionalEvent = "maneuverAdditionalEvent"

        static let additionalHide = "additionalHide"
        static let additionalExitName = "additionalExitName"
        static let additionalIconWithText = "additionalIconWithText"
        
        static let nextHidden = "nextHidden"
        static let nextManeuver = "nextManeuver"
    }

    private let model: Model
    private let eventChannel: DgisStreamHandler
    
    private var cancelable: Array<Cancellable> = []
    
    private var roadRules: RoadRuleRouteLongAttribute?
    private var instructions: InstructionRouteAttribute?
    
    init(model: Model, eventChannel: DgisStreamHandler) {
        self.model = model
        self.eventChannel = eventChannel
        
        self.cancelable.append(contentsOf: [
            self.model.routeChannel.sink(receiveValue: routeListener(_:)),
            self.model.routePositionChannel.sink(receiveValue: positionListener(_:)),
            self.model.stateChannel.sink(receiveValue: stateListener(_:))
        ])
    }
    
    func cancel() {
        self.cancelable.forEach { $0.cancel() }
        self.cancelable.removeAll()
    }
    
    private func routeListener(_ routeInfo: RouteInfo) {
        self.instructions = routeInfo.route.instructions
        self.roadRules = routeInfo.route.roadRules
        
        guard let routePosition = model.routePosition, let instructions = self.instructions else { return }
        
        self.getNextManeuverInfo(routePosition, instructions)
        self.getAdditionalManeuverInfo(routePosition, instructions)
    }
    
    private func positionListener(_ position: RoutePoint?) {
        guard let position = position, let instructions = self.instructions else  { return }

        self.getNextManeuverInfo(position, instructions)
        self.getAdditionalManeuverInfo(position, instructions)
    }
    
    private func stateListener(_ state: State) {
        guard let instructions = self.instructions, let position = model.routePosition else  { return }

        self.getNextManeuverInfo(position, instructions)
        self.getAdditionalManeuverInfo(position, instructions)
    }
    
    private func getNextManeuverInfo(_ position: RoutePoint, _ instructions: InstructionRouteAttribute) {
        if let nearBackward = instructions.findNearBackward(point: position) {
            if (position.distance.millimeters <= nearBackward.point.distance.millimeters + nearBackward.value.range.millimeters) {
                return self.getNextManeuverStateForInstruction(nearBackward, position)
            }
        }
        
        if let nearForward = instructions.findNearForward(point: position) {
            return getNextManeuverStateForInstruction(nearForward, position)
        }
    }
    
    private func getAdditionalManeuverInfo(_ position: RoutePoint, _ instructions: InstructionRouteAttribute) {
        guard let instructionEntry = instructions.findNearForward(point: position) else { return }
        
        let instruction = instructionEntry.value
        let instructionType = getInstructionManeuver(extraInstructionInfo: instruction.extraInstructionInfo)
        
        // Дополнительного маневра не должно быть у первой инструкции "Двигайтесь прямо",
        // а также у карточки "Вы на месте".
        if instructionEntry == instructions.first
            && (.crossroadStraight == instructionType || .finish == instructionType) {
            return
        }
        
        switch instruction.extraInstructionInfo {
        case .carRoundabout(let info):
            if (info.type == .exit) {
                return eventChannel.success([
                    "event": ManeuverEvents.maneuverAdditionalEvent,
                    "type": ManeuverEvents.additionalHide,
                ])
            }
            if (!info.exitName.isEmpty) {
                return eventChannel.success([
                    "event": ManeuverEvents.maneuverAdditionalEvent,
                    "type": ManeuverEvents.additionalExitName,
                    "value": info.exitName,
                ])
            } else if (info.exitNumber > 0) {
                return eventChannel.success([
                    "event": ManeuverEvents.maneuverAdditionalEvent,
                    "type": ManeuverEvents.additionalExitName,
                    "value": info.exitNumber,
                ])
            }
        case .carCrossroad(let info):
            if (!info.exitName.isEmpty) {
                return eventChannel.success([
                    "event": ManeuverEvents.maneuverAdditionalEvent,
                    "type": ManeuverEvents.additionalExitName,
                    "value": info.exitName,
                ])
            }
        case .carUturn(let info):
            if (!info.exitName.isEmpty) {
                return eventChannel.success([
                    "event": ManeuverEvents.maneuverAdditionalEvent,
                    "type": ManeuverEvents.additionalExitName,
                    "value": info.exitName,
                ])
            }
        default:
            break
        }
        
        if 1_000_000 < instructionEntry.point.distance.millimeters - position.distance.millimeters {
            return eventChannel.success([
                "event": ManeuverEvents.maneuverAdditionalEvent,
                "type": ManeuverEvents.additionalHide,
            ])
        }
        
        guard let nextInstructionEntry = instructions.findNearForward(
            point: RoutePoint(distance: RouteDistance(millimeters: instructionEntry.point.distance.millimeters + 1000))
        ) else {
            return eventChannel.success([
                "event": ManeuverEvents.maneuverAdditionalEvent,
                "type": ManeuverEvents.additionalHide,
            ])
        }
        let instructionManeuver = getInstructionManeuver(
            extraInstructionInfo: nextInstructionEntry.value.extraInstructionInfo
        )
        
        if instructionManeuver == .none {
            return eventChannel.success([
                "event": ManeuverEvents.maneuverAdditionalEvent,
                "type": ManeuverEvents.additionalHide,
            ])
        }
        
        let distance = nextInstructionEntry.point.distance.millimeters - instructionEntry.point.distance.millimeters
        if distance > 50_000 {
            return eventChannel.success([
                "event": ManeuverEvents.maneuverAdditionalEvent,
                "type": ManeuverEvents.additionalHide,
            ])
        }
        return eventChannel.success([
            "event": ManeuverEvents.maneuverAdditionalEvent,
            "type": ManeuverEvents.additionalIconWithText,
            "value": instructionManeuver.name(),
        ])
    }
    
    private func getNextManeuverStateForInstruction(
        _ instructionEntry: InstructionRouteEntry,
        _ routePosition: RoutePoint
    ) {
        let instruction = instructionEntry.value
        let distance = instructionEntry.point.distance.millimeters - routePosition.distance.millimeters
        
        if (distance <= 0 && instruction.roadName.isEmpty) {
            return eventChannel.success([
                "event": ManeuverEvents.maneuverEvent,
                "type": ManeuverEvents.nextHidden
            ])
        }

        let instructionType = getInstructionManeuver(extraInstructionInfo: instruction.extraInstructionInfo)

        NotificationCenter.default.post(
            name: .dgisNavigationManeuverTick,
            object: nil,
            userInfo: [
                "distanceMm": Double(distance),
                "roadName": instruction.roadName,
                "instruction": instructionType.name()
            ]
        )

        return eventChannel.success([
            "event": ManeuverEvents.maneuverEvent,
            "type": ManeuverEvents.nextManeuver,
            "distance": distance,
            "unit": "unit",
            "roadName": instruction.roadName,
            "instruction": instructionType.name(),
        ])
    }
}
