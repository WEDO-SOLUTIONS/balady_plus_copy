import Foundation

public struct VendorConfig: Decodable {
    var overrides: [String: String]
    
    // Метод для загрузки конфигурации из файла
    static func fromFile(path: String) -> VendorConfig? {
        let data = FileManager.default.contents(atPath: path)
        
        return data.flatMap {
            try? JSONDecoder().decode([VendorConfig].self, from: $0)[0]
        }
    }
    
    // Метод для загрузки конфигурации из строки JSON
    static func fromString(jsonString: String) -> VendorConfig? {
        guard let data = jsonString.data(using: .utf8) else { return nil }
        return try? JSONDecoder().decode(VendorConfig.self, from: data)
    }

}

enum CustomOverrides: String {
    case twinsApi = "Modules/twins/webapi_url"
}
