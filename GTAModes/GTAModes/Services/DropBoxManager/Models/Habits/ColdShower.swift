import Foundation

struct DBShowerResponse: Codable {

    private enum CodingKeys : String, CodingKey {
        case data = "rtyu"
    }
    
    var data: DBShowerData
}

struct DBShowerData: Codable {

    private enum CodingKeys : String, CodingKey {
        case items = "Benefits"
    }
    
    var items: [ColdShower]
}

struct ColdShower: Codable {
    
    private enum CodingKeys : String, CodingKey {
        case title = "rtyud6",
             descriptionText = "rtyuf4"
    }
    
    var title: String
    var descriptionText: String
}
