import Foundation

struct DBHeartRateResponse: Codable {

    private enum CodingKeys : String, CodingKey {
        case data = "rt4wx _list"
    }
    
    var data: DBHeartRateData
}

struct DBHeartRateData: Codable {

    private enum CodingKeys : String, CodingKey {
        case items = "Heart rate guide"
    }
    
    var items: [HeartRate]
}

struct HeartRate: Codable {
    
    private enum CodingKeys : String, CodingKey {
        case title = "rt4wxg5",
             descriptionText = "rt4wxk8"
    }
    
    var title: String
    var descriptionText: String?
}
