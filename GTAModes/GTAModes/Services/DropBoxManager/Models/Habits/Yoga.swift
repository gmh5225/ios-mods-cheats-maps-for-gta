import Foundation

struct DBYogaResponse: Codable {

    private enum CodingKeys : String, CodingKey {
        case data = "_m3uy_list"
    }
    
    var data: DBBreathingData
}

struct DBYogaData: Codable {

    private enum CodingKeys : String, CodingKey {
        case items = "Yoga"
    }
    
    var items: [Stretching]
}

struct Yoga: Codable {
    
    private enum CodingKeys : String, CodingKey {
        case isNew = "new",
             title = "_k1cji1",
             descriptionText = "_m3uym7"
    }
    
    var isNew: Bool
    var title: String
    var descriptionText: String
}
