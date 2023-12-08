import Foundation

public struct VendorConfig: Decodable {
    var overrides: [String: String]
    
    static func from(path: String) -> VendorConfig? {
        let data = FileManager.default.contents(atPath: path)
        
        return data.flatMap {
            try? JSONDecoder().decode([VendorConfig].self, from: $0)[0]
        }
    }
}

enum CustomOverrides: String {
    case twinsApi = "Modules/twins/webapi_url"
}
