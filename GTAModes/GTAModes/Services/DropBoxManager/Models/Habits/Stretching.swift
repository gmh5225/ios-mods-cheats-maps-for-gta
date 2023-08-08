import Foundation

struct DBStretchingResponse: Codable {

    private enum CodingKeys : String, CodingKey {
        case data = "_p7io_list"
    }
    
    var data: DBBreathingData
}

struct DBStretchingData: Codable {

    private enum CodingKeys : String, CodingKey {
        case items = "Stretching"
    }
    
    var items: [Stretching]
}

struct Stretching: Codable {
    
    private enum CodingKeys : String, CodingKey {
        case isNew = "new",
             title = "_k1cjo8",
             descriptionText = "_p7iom7"
    }
    
    var isNew: Bool
    var title: String
    var descriptionText: String
}
