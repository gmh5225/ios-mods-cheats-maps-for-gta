import Foundation

struct DBDrinkingResponse: Codable {

    private enum CodingKeys : String, CodingKey {
        case data = "trki _list"
    }
    
    var data: DBDrinkingData
}

struct DBDrinkingData: Codable {

    private enum CodingKeys : String, CodingKey {
        case items = "Drinking water"
    }
    
    var items: [Drinking]
}

struct Drinking: Codable {
    
    private enum CodingKeys : String, CodingKey {
        case title = "trkid6",
             descriptionText = "trkif4"
    }
    
    var title: String
    var descriptionText: String
}
