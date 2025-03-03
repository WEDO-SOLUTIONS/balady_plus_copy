import Foundation
import DGis

class CarPlayManeuver {
    
    init(roadName: String, instruction: DGis.InstructionRouteEntry, distanceRemaining: Measurement<UnitLength>, timeRemaining: TimeInterval) {
        self.roadName = roadName
        self.instruction = instruction
        self.distanceRemaining = distanceRemaining
        self.timeRemaining = timeRemaining
    }
    
    let roadName: String
    let instruction: DGis.InstructionRouteEntry
    let distanceRemaining : Measurement<UnitLength>
    let timeRemaining : TimeInterval
}
