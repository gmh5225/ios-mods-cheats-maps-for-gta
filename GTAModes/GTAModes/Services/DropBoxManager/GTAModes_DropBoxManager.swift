

import Foundation
import SwiftyDropbox
import RealmSwift

protocol DropBoxManagerDelegate: AnyObject {
    
    func gta_currentProgressOperation(progress : Progress)
    func gta_isReadyAllContent()
    
}

final class GTAModes_DBManager: NSObject {
    
    // MARK: - Private properties
    
    private let defaults = UserDefaults.standard
    private var isReadyContent : Bool = false
    
    // MARK: - Public properties
    
    static let shared = GTAModes_DBManager()
    var client: DropboxClient?
    weak var delegate: DropBoxManagerDelegate?
    
    
    // MARK: - For CoreData
    
    //    var persistentContainer = CoreDataManager.shared.persistentContainer
    
    // MARK: - Public
    
    func gta_setupDropBox() {
        if let _ = defaults.value(forKey: "dataDidLoaded") as? Bool {
            
        } else {
            gta_clearAllThings()
        }
        
        if let isLoadedData = defaults.value(forKey: "dataDidLoaded") as? Bool, !isLoadedData {
            gta_clearAllThings()
            
            if let refresh = defaults.value(forKey: DBKeys.RefreshTokenSaveVar) as? String {
                gta_getAllContent()
            } else {
                print("start resetting token operation")
                gta_reshreshToken(code: DBKeys.token) { [weak self] refresh_token in
                    guard let self = self else { return }
                    if let rToken = refresh_token {
                        print(rToken)
                        self.defaults.setValue(rToken, forKey: DBKeys.RefreshTokenSaveVar)
                    }
                    
                    gta_getAllContent()
                }
                
            }
        } else {
            delegate?.gta_isReadyAllContent()
            print(" ================== ALL DATA IS LOCALY OK =======================")
        }
    }
    
    func gta_getImageUrl(img: String, completion: @escaping (String?) -> ()){
        self.client?.files.getTemporaryLink(path: img).response(completionHandler: { responce, error in
            if let link = responce {
                completion(link.link)
            } else {
                completion(nil)
            }
        })
        
    }
    
    
//    func getFileUrl(path: String, completion: @escaping (String?) -> ()){
//        self.client?.files.getTemporaryLink(path: "/\(path)").response(completionHandler: { responce, error in
//            if let link = responce {
//                completion(link.link)
//            } else {
//                completion(nil)
//            }
//        })
//    }
    
//
//    func downloadFileBy(urlPath: URL, completion: @escaping (String?, Error?) -> Void) {
//        let fileURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//        let urlForDestination = fileURL.appendingPathComponent(urlPath.lastPathComponent)
//        if FileManager().fileExists(atPath: urlForDestination.path) {
//            print("File already exists [\(urlForDestination.path)]")
//            completion(urlForDestination.path, nil)
//        } else {
//            let configuration = URLSessionConfiguration.default
//            let urlSession = URLSession(configuration: configuration, delegate: nil, delegateQueue: nil)
//            var request = URLRequest(url: urlPath)
//            let httpMethod = "GET"
//            request.httpMethod = httpMethod
//            let urlDataTask = urlSession.dataTask(with: request, completionHandler: { data, response, error in
//                if error != nil {
//                    completion(urlForDestination.path, error)
//                } else {
//                    if let response = response as? HTTPURLResponse {
//                        if response.statusCode == 200 {
//                            if let data = data {
//                                if let _ = try? data.write(to: urlForDestination, options: Data.WritingOptions.atomic) {
//                                    completion(urlForDestination.path, error)
//                                } else {
//                                    completion(urlForDestination.path, error)
//                                }
//                            } else {
//                                completion(urlForDestination.path, error)
//                            }
//                        }
//                    }
//                }
//            })
//            urlDataTask.resume()
//        }
//    }
    
//    func downloadFileBy(urlPath: String, completion: @escaping (Data?) -> Void) {
//        self.client?.files.download(path:  "/\(urlPath)").response(completionHandler: { responce, error in
//            if let responce = responce {
//                completion(responce.1)
//            } else {
//                completion(nil)
//            }
//        })
//    }
    
}

// MARK: - Private

private extension GTAModes_DBManager {
    
    func gta_clearAllThings() {
        defaults.set(false, forKey: "dataDidLoaded")
        defaults.set(0, forKey: "json_categories_data_count")
        defaults.set(0, forKey: "json_data_count")
        defaults.set(0, forKey: "json_editor_data_count")
        //TODO: Clear CoreData if needed
    }
    
    
    
    func gta_validateAccessToken(token : String, completion: @escaping(Bool)->()) {
        self.gta_getTokenBy(refresh_token: token) { access_token in
            
            if let aToken = access_token {
                self.client = DropboxClient(accessToken:aToken)
                print("token updated !!! \(aToken),\(String(describing: self.client))")
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func gta_reshreshToken(code: String, completion: @escaping (String?) -> ()) {
        let username = DBKeys.appkey
        let password = DBKeys.appSecret
        let loginString = String(format: "%@:%@", username, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        let parameters: Data = "code=\(code)&grant_type=authorization_code".data(using: .utf8)!
        let url = URL(string: DBKeys.apiLink)!
        var apiRequest = URLRequest(url: url)
        apiRequest.httpMethod = "POST"
        apiRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type")
        apiRequest.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        apiRequest.httpBody = parameters
        let task = URLSession.shared.dataTask(with: apiRequest) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data Available")
                //ContentMagicLocker.shared.isLostConnection = true
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                completion(responseJSON[DBKeys.RefreshTokenSaveVar] as? String)
            } else {
                print("error")
            }
        }
        task.resume()
    }
    
    func gta_getTokenBy(refresh_token: String, completion: @escaping (String?) -> ()) {
        let loginString = String(format: "%@:%@", DBKeys.appkey, DBKeys.appSecret)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        let parameters: Data = "refresh_token=\(refresh_token)&grant_type=refresh_token".data(using: .utf8)!
        let url = URL(string: DBKeys.apiLink)!
        var apiRequest = URLRequest(url: url)
        apiRequest.httpMethod = "POST"
        apiRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type")
        apiRequest.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        apiRequest.httpBody = parameters
        let task = URLSession.shared.dataTask(with: apiRequest) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data Available")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                completion(responseJSON["access_token"] as? String)
            } else {
                print("error")
            }
        }
        task.resume()
    }
    
}

private extension GTAModes_DBManager {
    
    func gta_clearRealmData() {
        do {
            let realm = try Realm()
            try realm.write {
                realm.delete(realm.objects(MainItemObject.self))
                realm.delete(realm.objects(CheatObject.self))
                realm.delete(realm.objects(MissionObject.self))
            }
        } catch {
            print("Error deleting existing data: \(error)")
        }
    }
    
    func gta_getAllContent() {
        gta_clearRealmData()
        
        gta_fetchMainInfo { [ weak self] in
            print("============== MAIN INFO ALL OK =================")
            
            self?.fetchGameListInfo { [weak self] in
                print("============== GAME LIST ALL OK =================")
                self?.fetchGTA5Codes { [weak self] in
                    print("============== V5 ALL OK =================")
                    self?.fetchGTA6Codes { [weak self] in
                        print("============== V6 ALL OK =================")
                        self?.fetchGTAVCCodes { [weak self] in
                            print("============== VC ALL OK =================")
                            self?.fetchGTASACodes { [weak self] in
                                print("============== SA ALL OK =================")
                                
                                self?.fetchMissions { [weak self] in
                                    print("============== ALL OK ALL OK ALL OK =================")
                                    self?.delegate?.gta_isReadyAllContent()
                                    self?.defaults.set(true, forKey: "dataDidLoaded")
                                }
                                
                                
                            }
                        }
                    }
                }
            }
        }
    }
    
    func gta_fetchMainInfo(completion: @escaping () -> (Void)) {
        gta_validateAccessToken(token: DBKeys.refresh_token) { [weak self] validator in
            guard let self = self else { return }
            
            if validator {
                self.client?.files.download(path: DBKeys.Path.main.rawValue)
                    .response(completionHandler: { responce, error in
                        if let data = responce?.1 {
                            do {
                                let decoder = JSONDecoder()
                                let decodedData = try decoder.decode(MainItemsDataParser.self, from: data)
                                self.addMenuItemToDB(decodedData, type: "main", completion: completion)
                                
                            } catch {
                                print("Error decoding JSON: \(error)")
                            }
                        } else {
                            completion()
                            print(error?.description)
                        }
                    })
            } else {
                completion()
                let tempError = NSError(domain: "", code: 401, userInfo: [ NSLocalizedDescriptionKey: "Unauthorized error"])
            }
        }
    }
    
    func fetchGameListInfo(completion: @escaping () -> (Void)) {
        gta_validateAccessToken(token: DBKeys.refresh_token) { [weak self] validator in
            guard let self = self else { return }
            
            if validator {
                self.client?.files.download(path: DBKeys.Path.gameList.rawValue)
                    .response(completionHandler: { responce, error in
                        if let data = responce?.1 {
                            do {
                                let decoder = JSONDecoder()
                                let decodedData = try decoder.decode(MainItemsDataParser.self, from: data)
                                self.addMenuItemToDB(decodedData, type: "gameList", completion: completion)
                                
                            } catch {
                                completion()
                                print("Error decoding JSON: \(error)")
                            }
                        } else {
                            completion()
                            print(error?.description)
                        }
                    })
            } else {
                completion()
                let tempError = NSError(domain: "", code: 401, userInfo: [ NSLocalizedDescriptionKey: "Unauthorized error"])
            }
        }
    }
    
    func addMenuItemToDB(
        _ itemsMenu: MainItemsDataParser,
        type: String,
        completion: @escaping () -> Void
    ) {
        let list = itemsMenu.data.map { $0.imagePath }
        var trueImagePath: [String] = []
        var processedCount = 0
        
        func processNextImage(index: Int) {
            guard index < list.count else {
                // All images have been processed, call completion
                self.saveMainItemsToRealm(itemsMenu, trueImagePath, type: type)
                completion()
                return
            }
            
            let path = list[index]
            gta_getImageUrl(img: "/\(type)/" + path) { [weak self] truePath in
                processedCount += 1
                trueImagePath.append(truePath ?? "")
                
                if processedCount == list.count {
                    self?.saveMainItemsToRealm(itemsMenu, trueImagePath, type: type)
                    completion()
                } else {
                    processNextImage(index: index + 1) // Process next image
                }
            }
        }
        
        // Start processing the first image
        processNextImage(index: 0)
    }

    
    func saveMainItemsToRealm(
        _ itemsMenu: MainItemsDataParser,
        _ trueImagePath: [String]
        , type: String
    ) {
        do {
            let realm = try Realm()
            try realm.write {
                for (index, item) in itemsMenu.data.enumerated() {
                    let mainItemObject = MainItemObject(
                        title: item.title,
                        type: item.type,
                        imagePath: trueImagePath[index],
                        rawTypeItem: type
                    )
                    realm.add(mainItemObject)
                }
            }
        } catch {
            print("Error saving data to Realm: \(error)")
        }
    }
}

extension GTAModes_DBManager {

    func fetchGTA5Codes(completion: @escaping () -> (Void)) {
        gta_validateAccessToken(token: DBKeys.refresh_token) { [weak self] validator in
            guard let self = self else { return }
            
            if validator {
                self.client?.files.download(path: DBKeys.Path.gta5_modes.rawValue)
                    .response(completionHandler: { [weak self] responce, error in
                        guard let self = self else { return }
                        
                        if let data = responce?.1 {
                            do {
                                let decoder = JSONDecoder()
                                let decodedData = try decoder.decode(CheatCodesGTA5Parser.self, from: data)
                                self.saveCheatItemToRealm(decodedData.GTA5, gameVersion: "GTA5")
                                completion()
                            } catch {
                                completion()
                                print("Error decoding JSON: \(error)")
                            }
                        } else {
                            completion()
                            print(error?.description)
                        }
                    })
            } else {
                completion()
                let tempError = NSError(domain: "", code: 401, userInfo: [ NSLocalizedDescriptionKey: "Unauthorized error"])
            }
        }
    }
    
    func fetchGTA6Codes(completion: @escaping () -> (Void)) {
        gta_validateAccessToken(token: DBKeys.refresh_token) { [weak self] validator in
            guard let self = self else { return }
            
            if validator {
                self.client?.files.download(path: DBKeys.Path.gta6_modes.rawValue)
                    .response(completionHandler: { responce, error in
                        if let data = responce?.1 {
                            do {
                                let decoder = JSONDecoder()
                                let decodedData = try decoder.decode(CheatCodesGTA6Parser.self, from: data)
                                self.saveCheatItemToRealm(decodedData.GTA6, gameVersion: "GTA6")
                                completion()
                            } catch {
                                completion()
                                print("Error decoding JSON: \(error)")
                            }
                        } else {
                            completion()
                            print(error?.description)
                        }
                    })
            } else {
                completion()
                let tempError = NSError(domain: "", code: 401, userInfo: [ NSLocalizedDescriptionKey: "Unauthorized error"])
            }
        }
    }
    
    func fetchGTAVCCodes(completion: @escaping () -> (Void)) {
        gta_validateAccessToken(token: DBKeys.refresh_token) { [weak self] validator in
            guard let self = self else { return }
            
            if validator {
                self.client?.files.download(path: DBKeys.Path.gtavc_modes.rawValue)
                    .response(completionHandler: { responce, error in
                        if let data = responce?.1 {
                            do {
                                let decoder = JSONDecoder()
                                let decodedData = try decoder.decode(CheatCodesGTAVCParser.self, from: data)
                                self.saveCheatItemToRealm(decodedData.GTA_Vice_City, gameVersion: "GTAVC")
                                completion()
                            } catch {
                                completion()
                                print("Error decoding JSON: \(error)")
                            }
                        } else {
                            completion()
                            print(error?.description)
                        }
                    })
            } else {
                completion()
                let tempError = NSError(domain: "", code: 401, userInfo: [ NSLocalizedDescriptionKey: "Unauthorized error"])
            }
        }
    }
    
    func fetchGTASACodes(completion: @escaping () -> (Void)) {
        gta_validateAccessToken(token: DBKeys.refresh_token) { [weak self] validator in
            guard let self = self else { return }
            
            if validator {
                self.client?.files.download(path: DBKeys.Path.gtasa_modes.rawValue)
                    .response(completionHandler: { [weak self] responce, error in
                        guard let self = self else { return }
                        
                        if let data = responce?.1 {
                            do {
                                let decoder = JSONDecoder()
                                let decodedData = try decoder.decode(CheatCodesGTASAParser.self, from: data)
                                self.saveCheatItemToRealm(decodedData.GTA_San_Andreas, gameVersion: "GTASA")
                                completion()
                            } catch {
                                completion()
                                print("Error decoding JSON: \(error)")
                            }
                        } else {
                            completion()
                            print(error?.description)
                        }
                    })
            } else {
                completion()
                let tempError = NSError(domain: "", code: 401, userInfo: [ NSLocalizedDescriptionKey: "Unauthorized error"])
            }
        }
    }
    
    func fetchMissions(completion: @escaping () -> (Void)) {
        gta_validateAccessToken(token: DBKeys.refresh_token) { [weak self] validator in
            guard let self = self else { return }
            
            if validator {
                self.client?.files.download(path: DBKeys.Path.checkList.rawValue)
                    .response(completionHandler: { [weak self] responce, error in
                        guard let self = self else { return }
                        
                        if let data = responce?.1 {
                            do {
                                //
                                let decoder = JSONDecoder()
                                let decodedData = try decoder.decode(MissionParser.self, from: data)
                                
                                let allMissionCategories: [MissionCategory] = [
                                    decodedData.randomEvents,
                                    decodedData.strangersAndFreaks,
                                    decodedData.mandatoryMissionStrangersAndFreaks,
                                    decodedData.strangersAndFreaksHobbiesAndPastimes,
                                    decodedData.sideMission,
                                    decodedData.mandatoryMissionHeist,
                                    decodedData.branchingChoiceHeist,
                                    decodedData.branchingChoice,
                                    decodedData.missableMission,
                                    decodedData.mandatoryMission,
                                    decodedData.misscellaneous,
                                    decodedData.randomMission,
                                    decodedData.strangers,
                                    decodedData.hobby,
                                    decodedData.task
                                ]
                                self.saveMissionsToRealm(allMissionCategories)
                                completion()
                            } catch {
                                completion()
                                print("Error decoding JSON: \(error)")
                            }
                        } else {
                            completion()
                            print(error?.description)
                        }
                    })
            } else {
                completion()
                let tempError = NSError(domain: "", code: 401, userInfo: [ NSLocalizedDescriptionKey: "Unauthorized error"])
            }
        }
    }
    
    func saveCheatItemToRealm(
        _ cheatCodesParser: CheatCodesPlatformParser,
        gameVersion: String
    ) {
        do {
            let realm = try Realm()
            
            try realm.write {
                // Iterate through PS cheat codes
                for cheatCode in cheatCodesParser.ps {
                    let cheatObject = CheatObject(
                        name: cheatCode.name,
                        code: cheatCode.code,
                        filterTitle: cheatCode.filterTitle,
                        platform: "ps",
                        game: gameVersion,
                        isFavorite: false
                    )
                    realm.add(cheatObject)
                }
                
                // Iterate through Xbox cheat codes
                for cheatCode in cheatCodesParser.xbox {
                    let cheatObject = CheatObject(
                        name: cheatCode.name,
                        code: cheatCode.code,
                        filterTitle: cheatCode.filterTitle,
                        platform: "xbox",
                        game: gameVersion,
                        isFavorite: false
                    )
                    realm.add(cheatObject)
                }
                if let pcCheats = cheatCodesParser.pc {
                    for cheatCode in pcCheats {
                        let cheatObject = CheatObject(
                            name: cheatCode.name,
                            code: cheatCode.code,
                            filterTitle: cheatCode.filterTitle,
                            platform: "pc",
                            game: gameVersion,
                            isFavorite: false
                        )
                        realm.add(cheatObject)
                    }
                }
            }
        } catch {
            print("Error saving data to Realm: \(error)")
        }
    }
    
    func saveMissionsToRealm(
        _ missions: [MissionCategory]
    ) {
        do {
            let realm = try Realm()
            
            try realm.write {
                for mission in missions {
                    mission.missions.forEach { missionName in
                        let missionObject = MissionObject(
                            category: mission.name,
                            name: missionName,
                            isCheck: false)
                        realm.add(missionObject)
                    }
                }
            }
        } catch {
            print("Error saving data to Realm: \(error)")
        }
    }
    
}
