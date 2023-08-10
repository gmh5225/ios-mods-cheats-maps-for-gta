//import Foundation
//
//public final class CheatManager {
//    
//    init() {
//    }
//    
//    public func getCheats() {
//        
//        if let path = Bundle.main.path(forResource: "cheats_GTA5", ofType: "json") {
//            do {
//                let jsonData = try Data(contentsOf: URL(fileURLWithPath: path))
//                let decoder = JSONDecoder()
//                let cheatCodePlatforms = try decoder.decode([String: [CheatCode]].self, from: jsonData)
//                
//                // Преобразование в массив структур CheatCodePlatform
//                var cheatCodePlatformsArray: [CheatCodePlatform] = []
//                for (platform, cheatCodes) in cheatCodePlatforms {
//                    let cheatCodePlatform = CheatCodePlatform(platform: platform, cheatCodes: cheatCodes)
//                    cheatCodePlatformsArray.append(cheatCodePlatform)
//                }
//                print(cheatCodePlatforms.count)
//            } catch {
//                print("Ошибка при декодировании JSON: \(error)")
//            }
//        } else {
//            print("Не удается найти файл JSON.")
//        }
//
//    }
//}
