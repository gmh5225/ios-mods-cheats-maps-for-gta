import Foundation

struct DBRunningResponse: Codable {

    private enum CodingKeys : String, CodingKey {
        case data = "re3ghj _list"
    }
    
    var data: DBBreathingData
}

struct DBRunningData: Codable {

    private enum CodingKeys : String, CodingKey {
        case items = "10 amazing benefits of running"
    }
    
    var items: [Running]
}

struct Running: Codable {
    
    private enum CodingKeys : String, CodingKey {
        case title = "re3ghjr5",
             descriptionText = "re3ghjy7"
    }
    
    var title: String
    var descriptionText: String
}
