import Foundation

struct DBCyclingResponse: Codable {

    private enum CodingKeys : String, CodingKey {
        case data = "on5gh _list"
    }
    
    var data: DBCyclingData
}

struct DBCyclingData: Codable {

    private enum CodingKeys : String, CodingKey {
        case items = "Cyclin - health benefits"
    }
    
    var items: [Cycling]
}

struct Cycling: Codable {
    
    private enum CodingKeys : String, CodingKey {
        case title = "on5ghp7",
             descriptionText = "on5ghk2"
    }
    
    var title: String
    var descriptionText: String
}
