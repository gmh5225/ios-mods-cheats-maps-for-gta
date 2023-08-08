import Foundation

struct DBMeditationResponse: Codable {

    private enum CodingKeys : String, CodingKey {
        case data = "_k7bn_list"
    }
    
    var data: DBBreathingData
}

struct DBMeditationData: Codable {

    private enum CodingKeys : String, CodingKey {
        case items = "Meditation"
    }
    
    var items: [Meditation]
}

struct Meditation: Codable {
    
    private enum CodingKeys : String, CodingKey {
        case isNew = "new",
             title = "_k1cjr4",
             videoPath = "_k7bnm7"
    }
    
    var isNew: Bool
    var title: String
    var videoPath: String?
}
