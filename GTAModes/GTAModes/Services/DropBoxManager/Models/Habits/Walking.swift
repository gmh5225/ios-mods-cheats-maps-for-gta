import Foundation

struct DBWalkingResponse: Codable {

    private enum CodingKeys : String, CodingKey {
        case data = "ty4hj _list"
    }
    
    var data: DBBreathingData
}

struct DBWalkingData: Codable {

    private enum CodingKeys : String, CodingKey {
        case items = "Walking articles"
    }
    
    var items: [Walking]
}

struct Walking: Codable {
    
    private enum CodingKeys : String, CodingKey {
        case title = "ty4hju6",
             descriptionText = "ty4hjk3"
    }
    
    var title: String
    var descriptionText: String
}
