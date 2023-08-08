import Foundation

struct DBBreathingResponse: Codable {

    private enum CodingKeys : String, CodingKey {
        case data = "_p2rt_list"
    }
    
    var data: DBBreathingData
}

struct DBBreathingData: Codable {

    private enum CodingKeys : String, CodingKey {
        case items = "Breathing"
    }
    
    var items: [Breathing]
}

struct Breathing: Codable {
    
    private enum CodingKeys : String, CodingKey {
        case isNew = "new",
             title = "_k1cjm6",
             videoPath = "_p2rtn8"
    }
    
    var isNew: Bool
    var title: String
    var videoPath: String?
}
