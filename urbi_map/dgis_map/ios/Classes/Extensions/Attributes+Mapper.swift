import Foundation
import DGis

extension Attributes {
    func mapIo(_ point: GeoPointWithElevation) -> [String: Any] {
        return [
            "event": ObjectTapHandler.Events.onIoTap,
            "description": self.stringOrEmpty("OPPORTUNITYDESCRIPTION"),
            "area": self.numberOrEmpty("TOTALSPACEINMETERS"),
            "status": self.stringOrEmpty("STATUS"),
            "price": self.numberOrEmpty("RFPPRICE"),
            "startDate": self.stringOrEmpty("STARTDATE"),
            "endDate": self.stringOrEmpty("ENDDATE"),
            "type": self.stringOrEmpty("OPPORTUNITYTYPE"),
            "latitude": point.latitude.value,
            "longitude": point.longitude.value,
        ];
    }
    
    func mapIdle(_ point: GeoPointWithElevation) -> [String: Any] {
        return [
            "event": ObjectTapHandler.Events.onIdleTap,
            "landuse": self.stringOrEmpty("LANDUSE"),
            "description": self.stringOrEmpty("DESCRIPTION"),
            "area": self.numberOrEmpty("PARCELAREA"),
            "parcelName": self.stringOrEmpty("PARCELNAME"),
            "phase": self.stringOrEmpty("PHASE"),
            "createdDate": self.stringOrEmpty("CREATED_DATE"),
            "amanaName": self.stringOrEmpty("AMANANAME"),
            "munName": self.stringOrEmpty("MUNNAME"),
            "status": self.stringOrEmpty("STATUS"),
            "streetName": self.stringOrEmpty("STREETNAME"),
            "planNo": self.stringOrEmpty("PLANNO"),
            "latitude": point.latitude.value,
            "longitude": point.longitude.value,
        ];
    }
    
    private func stringOrEmpty(_ name: String) -> String {
        guard case .string(let value) = self.getAttributeValue(name: name) else {
            return ""
        }
        
        return value
    }
    
    private func intOrEmpty(_ name: String) -> Int64 {
        guard case .integer(let value) = self.getAttributeValue(name: name) else {
            return -1
        }
        
        return value
    }
    
    private func numberOrEmpty(_ name: String) -> Double {
        guard case .number(let value) = self.getAttributeValue(name: name) else {
            return -1.0
        }
        
        return value
    }
}
