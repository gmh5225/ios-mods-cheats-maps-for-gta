

import Foundation
import SwiftyDropbox
import RealmSwift

protocol GTA_DropBoxManagerDelegate: AnyObject {
    
//    func gta_currentProgressOperation(progress : Progress)
    func gta_isReadyMain()
    func gta_isReadyGameList()
    func gta_isReadyGameCodes()
    func gta_isReadyMissions()
    func gta_isReadyGTA5Mods()
}

final class GTAModes_DBManager: NSObject {
    
    // MARK: - Private properties
    
    private let defaults = UserDefaults.standard
    private var isReadyContent : Bool = false
    
    // MARK: - Public properties
    
    static let shared = GTAModes_DBManager()
    var client: DropboxClient?
    weak var delegate: GTA_DropBoxManagerDelegate?
    
    
    // MARK: - For CoreData
    
    //    var persistentContainer = CoreDataManager.shared.persistentContainer
    
    // MARK: - Public
    
    func gta_setupDropBox() {
        
        if defaults.value(forKey: "gta_isReadyGTA5Mods") == nil {
            gta_clearAllThings()
        }
        if let isLoadedData = defaults.value(forKey: "gta_isReadyGTA5Mods") as? Bool, !isLoadedData {
            gta_clearAllThings()
            
            if let refresh = defaults.value(forKey: GTA_DBKeys.RefreshTokenSaveVar) as? String {
                gta_getAllContent()
            } else {
                print("start resetting token operation")
                gta_reshreshToken(code: GTA_DBKeys.token) { [weak self] refresh_token in
                    guard let self = self else { return }
                    if let rToken = refresh_token {
                        print(rToken)
                        self.defaults.setValue(rToken, forKey: GTA_DBKeys.RefreshTokenSaveVar)
                    }
                    
                    gta_getAllContent()
                }
                
            }
        } else {
            do {
                let realm = try Realm()
                let modes = realm.objects(MainItemObject.self)
                if modes.isEmpty {
                    gta_clearAllThings()
                    gta_getAllContent()
                } else {
                    delegate?.gta_isReadyMain()
                    print(" ================== ALL DATA IS LOCALY OK =======================")
                }
            } catch {
                gta_clearAllThings()
                gta_getAllContent()
                print("Error saving data to Realm: \(error)")
            }
            
            
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
    
    
    //    func gta_getFileUrl(path: String, completion: @escaping (String?) -> ()){
    //        self.client?.files.getTemporaryLink(path: path).response(completionHandler: { responce, error in
    //            if let link = responce {
    //                completion(link.link)
    //            } else {
    //                completion(nil)
    //            }
    //        })
    //    }
    
    //
    func gta_downloadMode(mode: ModItem, completion: @escaping (String?) -> ()) {
        gta_downloadFileBy(urlPath: mode.modPath) { [weak self] modeData in
            if let modeData = modeData {
                self?.gta_saveDataLocal(modeName: mode.modPath, data: modeData, completion: completion)
            } else {
                completion(nil)
            }
        }
    }
    
    func gta_downloadFileBy(urlPath: String, completion: @escaping (Data?) -> Void) {
        gta_validateAccessToken(token: GTA_DBKeys.refresh_token) { [weak self] validator in
            guard let self = self else { return }
            
            if validator {
                self.client?.files.download(path:  "/mods/" + urlPath).response(completionHandler: { responce, error in
                    if let responce = responce {
                        completion(responce.1)
                    } else {
                        completion(nil)
                    }
                })
            } else {
                completion(nil)
                print("ERROR")
            }
            
        }
    }
    
    func gta_saveDataLocal(modeName: String, data: Data, completion: @escaping (String?) -> ()) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent(modeName)
        do {
            try data.write(to: fileURL, options: .atomic)
            completion(fileURL.lastPathComponent)
        } catch {
            completion(nil)
        }
    }
    
}

// MARK: - Private

private extension GTAModes_DBManager {
    
    func gta_clearAllThings() {
        defaults.set(false, forKey: "gta_isReadyMain")
        defaults.set(false, forKey: "gta_isReadyGameList")
        defaults.set(false, forKey: "gta_isReadyGameCodes")
        defaults.set(false, forKey: "gta_isReadyMissions")
        defaults.set(false, forKey: "gta_isReadyGTA5Mods")
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
        let username = GTA_DBKeys.appkey
        let password = GTA_DBKeys.appSecret
        let loginString = String(format: "%@:%@", username, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        let parameters: Data = "code=\(code)&grant_type=authorization_code".data(using: .utf8)!
        let url = URL(string: GTA_DBKeys.apiLink)!
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
                completion(responseJSON[GTA_DBKeys.RefreshTokenSaveVar] as? String)
            } else {
                print("error")
            }
        }
        task.resume()
    }
    
    func gta_getTokenBy(refresh_token: String, completion: @escaping (String?) -> ()) {
        let loginString = String(format: "%@:%@", GTA_DBKeys.appkey, GTA_DBKeys.appSecret)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        let parameters: Data = "refresh_token=\(refresh_token)&grant_type=refresh_token".data(using: .utf8)!
        let url = URL(string: GTA_DBKeys.apiLink)!
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
                realm.delete(realm.objects(ModObject.self))
//
            }
        } catch {
            print("Error deleting existing data: \(error)")
        }
    }
    
    func gta_getAllContent() {
        gta_clearRealmData()
        
        gta_fetchMainInfo { [ weak self] in
            print("============== MAIN INFO ALL OK =================")
            self?.defaults.set(true, forKey: "gta_isReadyMain")
            self?.delegate?.gta_isReadyMain()
            
            self?.fetchGameListInfo { [weak self] in
                print("============== GAME LIST ALL OK =================")
                
//                self?.delegate?.gta_isReadyGameList()
                self?.defaults.set(true, forKey: "gta_isReadyGameList")
                self?.delegate?.gta_isReadyGameList()
                
                self?.fetchGTA5Codes { [weak self] in
                    print("============== V5 ALL OK =================")
                    self?.fetchGTA6Codes { [weak self] in
                        print("============== V6 ALL OK =================")
                        self?.fetchGTAVCCodes { [weak self] in
                            print("============== VC ALL OK =================")
                            self?.fetchGTASACodes { [weak self] in
                                print("============== SA ALL OK =================")
                                
                                self?.defaults.set(true, forKey: "gta_isReadyGameCodes")
                                self?.delegate?.gta_isReadyGameCodes()
                                
                                self?.fetchMissions { [weak self] in
                                    
                                    self?.defaults.set(true, forKey: "gta_isReadyMissions")
                                    self?.delegate?.gta_isReadyMissions()
                                    
                                    self?.fetchGTA5Mods { [weak self] in
                                        print("============== ALL OK ALL OK ALL OK =================")
                                        
                                        self?.delegate?.gta_isReadyGTA5Mods()
                                        self?.defaults.set(true, forKey: "gta_isReadyGTA5Mods")
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func gta_fetchMainInfo(completion: @escaping () -> (Void)) {
        gta_validateAccessToken(token: GTA_DBKeys.refresh_token) { [weak self] validator in
            guard let self = self else { return }
            
            if validator {
                self.client?.files.download(path: GTA_DBKeys.gta_Path.main.rawValue)
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
        gta_validateAccessToken(token: GTA_DBKeys.refresh_token) { [weak self] validator in
            guard let self = self else { return }
            
            if validator {
                self.client?.files.download(path: GTA_DBKeys.gta_Path.gameList.rawValue)
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
        gta_validateAccessToken(token: GTA_DBKeys.refresh_token) { [weak self] validator in
            guard let self = self else { return }
            
            if validator {
                self.client?.files.download(path: GTA_DBKeys.gta_Path.gta5_modes.rawValue)
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
        gta_validateAccessToken(token: GTA_DBKeys.refresh_token) { [weak self] validator in
            guard let self = self else { return }
            
            if validator {
                self.client?.files.download(path: GTA_DBKeys.gta_Path.gta6_modes.rawValue)
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
        gta_validateAccessToken(token: GTA_DBKeys.refresh_token) { [weak self] validator in
            guard let self = self else { return }
            
            if validator {
                self.client?.files.download(path: GTA_DBKeys.gta_Path.gtavc_modes.rawValue)
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
        gta_validateAccessToken(token: GTA_DBKeys.refresh_token) { [weak self] validator in
            guard let self = self else { return }
            
            if validator {
                self.client?.files.download(path: GTA_DBKeys.gta_Path.gtasa_modes.rawValue)
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
        gta_validateAccessToken(token: GTA_DBKeys.refresh_token) { [weak self] validator in
            guard let self = self else { return }
            
            if validator {
                self.client?.files.download(path: GTA_DBKeys.gta_Path.checkList.rawValue)
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
    
    func fetchGTA5Mods(completion: @escaping () -> (Void)) {
        gta_validateAccessToken(token: GTA_DBKeys.refresh_token) { [weak self] validator in
            guard let self = self else { return }
            
            if validator {
                self.client?.files.download(path: GTA_DBKeys.gta_Path.modsGTA5List.rawValue)
                    .response(completionHandler: { [weak self] responce, error in
                        guard let self = self else { return }
                        
                        if let data = responce?.1 {
                            do {
                                let decoder = JSONDecoder()
                                let decodedData = try decoder.decode(GTA5Mods.self, from: data)
                                self.configureModes(decodedData.GTA5["mods"] ?? [], completion: completion)
                                
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
    
    func configureModes(_ modes: [ModParser], completion: @escaping () -> Void) {
        let list = modes.map { $0.image }
        
        var trueImagePath: [String] = []
        var processedCount = 0
        
        func processNextImage(index: Int) {
            guard index < list.count else {
                // All images have been processed, call completion
                self.saveModesToRealm(modes, trueImagePath: trueImagePath)
                completion()
                return
            }
            
            let path = list[index]
            gta_getImageUrl(img: "/mods/" + path) { [weak self] truePath in
                processedCount += 1
                trueImagePath.append(truePath ?? "")
                
                if processedCount == list.count {
                    self?.saveModesToRealm(modes, trueImagePath: trueImagePath)
                    completion()
                } else {
                    processNextImage(index: index + 1) // Process next image
                }
            }
        }
        
        // Start processing the first image
        processNextImage(index: 0)
    }
    
    
    
    func saveModesToRealm(_ modes: [ModParser], trueImagePath: [String]) {
        do {
            let realm = try Realm()
            try realm.write {
                for (index, item) in modes.enumerated() {
                    let modItemObject = ModObject(
                        titleMod: item.title,
                        descriptionMod: item.description,
                        imagePath: trueImagePath[index].isEmpty ? item.image : trueImagePath[index]  ,
                        modPath: item.mod,
                        filterTitle: item.filterTitle
                    )
                    realm.add(modItemObject)
                }
            }
        } catch {
            print("Error saving data to Realm: \(error)")
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
