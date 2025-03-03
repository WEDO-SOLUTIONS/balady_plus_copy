import Foundation

class CarPlayEstimates {
    
    init(distanceRemaining: Measurement<UnitLength>, timeRemaining: TimeInterval) {
        self.distanceRemaining = distanceRemaining
        self.timeRemaining = timeRemaining
    }
    
    let distanceRemaining: Measurement<UnitLength>
    let timeRemaining: TimeInterval
}
