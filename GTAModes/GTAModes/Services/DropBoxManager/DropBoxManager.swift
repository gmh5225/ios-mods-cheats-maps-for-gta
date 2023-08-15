

import Foundation
import SwiftyDropbox
import RealmSwift

protocol DropBoxManagerDelegate : AnyObject {
    func currentProgressOperation(progress : Progress)
    func isReadyAllContent()
}

final class DBManager : NSObject {
    
    // MARK: - Private properties
    
    private let defaults = UserDefaults.standard
    private var isReadyContent : Bool = false
    
    
    // MARK: - Public properties
    
    static let shared = DBManager()
    var client: DropboxClient?
    weak var delegate: DropBoxManagerDelegate?
    
    
    // MARK: - For CoreData
    
    //    var persistentContainer = CoreDataManager.shared.persistentContainer
    
    // MARK: - Public
    
    func setupDropBox() {
        if let _ = defaults.value(forKey: "dataDidLoaded") as? Bool {
            
        } else {
            clearAllThings()
        }
        
        if let isLoadedData = defaults.value(forKey: "dataDidLoaded") as? Bool, !isLoadedData {
            clearAllThings()
            
            if let refresh = defaults.value(forKey: DBKeys.RefreshTokenSaveVar) as? String {
                fetchMainAndGameListInfo()
            } else {
                print("start resetting token operation")
                reshreshToken(code: DBKeys.token) { [weak self] refresh_token in
                    guard let self = self else { return }
                    if let rToken = refresh_token {
                        print(rToken)
                        self.defaults.setValue(rToken, forKey: DBKeys.RefreshTokenSaveVar)
                    }
                    
                    fetchMainAndGameListInfo()
                }
                
            }
        } else {
            print(" ================== ALL DATA IS LOCALY OK =======================")
        }
    }
    
    func getImageUrl(img: String, completion: @escaping (String?) -> ()){
        self.client?.files.getTemporaryLink(path: img).response(completionHandler: { responce, error in
            if let link = responce {
                completion(link.link)
            } else {
                completion(nil)
            }
        })
        
    }
    
    
    func getFileUrl(path: String, completion: @escaping (String?) -> ()){
        self.client?.files.getTemporaryLink(path: "/\(path)").response(completionHandler: { responce, error in
            if let link = responce {
                completion(link.link)
            } else {
                completion(nil)
            }
        })
    }
    
    
    func downloadFileBy(urlPath: URL, completion: @escaping (String?, Error?) -> Void) {
        let fileURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let urlForDestination = fileURL.appendingPathComponent(urlPath.lastPathComponent)
        if FileManager().fileExists(atPath: urlForDestination.path) {
            print("File already exists [\(urlForDestination.path)]")
            completion(urlForDestination.path, nil)
        } else {
            let configuration = URLSessionConfiguration.default
            let urlSession = URLSession(configuration: configuration, delegate: nil, delegateQueue: nil)
            var request = URLRequest(url: urlPath)
            let httpMethod = "GET"
            request.httpMethod = httpMethod
            let urlDataTask = urlSession.dataTask(with: request, completionHandler: { data, response, error in
                if error != nil {
                    completion(urlForDestination.path, error)
                } else {
                    if let response = response as? HTTPURLResponse {
                        if response.statusCode == 200 {
                            if let data = data {
                                if let _ = try? data.write(to: urlForDestination, options: Data.WritingOptions.atomic) {
                                    completion(urlForDestination.path, error)
                                } else {
                                    completion(urlForDestination.path, error)
                                }
                            } else {
                                completion(urlForDestination.path, error)
                            }
                        }
                    }
                }
            })
            urlDataTask.resume()
        }
    }
    
    func downloadFileBy(urlPath: String, completion: @escaping (Data?) -> Void) {
        self.client?.files.download(path:  "/\(urlPath)").response(completionHandler: { responce, error in
            if let responce = responce {
                completion(responce.1)
            } else {
                completion(nil)
            }
        })
    }
    
}

// MARK: - Private

private extension DBManager {
    
    func clearAllThings() {
        defaults.set(false, forKey: "dataDidLoaded")
        defaults.set(0, forKey: "json_categories_data_count")
        defaults.set(0, forKey: "json_data_count")
        defaults.set(0, forKey: "json_editor_data_count")
        //TODO: Clear CoreData if needed
    }
    
    
    
    func validateAccessToken(token : String, completion: @escaping(Bool)->()) {
        self.getTokenBy(refresh_token: token) { access_token in
            
            if let aToken = access_token {
                self.client = DropboxClient(accessToken:aToken)
                print("token updated !!! \(aToken),\(String(describing: self.client))")
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func reshreshToken(code: String, completion: @escaping (String?) -> ()) {
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
    
    func getTokenBy(refresh_token: String, completion: @escaping (String?) -> ()) {
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

private extension DBManager {
    
    func fetchMainAndGameListInfo() {
        do {
            let realm = try Realm()
            try realm.write {
                realm.delete(realm.objects(MainItemObject.self))
                realm.delete(realm.objects(CheatObject.self))
            }
            fetchMainInfo { [ weak self] _ in
                print("============== MAIN INFO ALL OK =================")
                self?.fetchGameListInfo { [weak self] _ in
                    print("============== GAME LIST ALL OK =================")
                    self?.fetchGTA5Codes { [weak self] _ in
                        print("============== V5 ALL OK =================")
                        self?.fetchGTA6Codes { [weak self] _ in
                            print("============== V6 ALL OK =================")
                            self?.fetchGTAVCCodes { [weak self] _ in
                                print("============== VC ALL OK =================")
                                self?.fetchGTASACodes { [weak self] _ in
                                    print("============== SA ALL OK =================")
                                    print("============== ALL OK ALL OK ALL OK =================")
                                    self?.defaults.set(true, forKey: "dataDidLoaded")

                                }
                            }
                        }
                    }
                }
            }
        } catch {
            print("Error deleting existing data: \(error)")
        }
    }
    
    func fetchMainInfo(completion: @escaping (Void?) -> ()) {
        validateAccessToken(token: DBKeys.refresh_token) { [weak self] validator in
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
                        completion(())
                        print(error?.description)
                    }
                })
            } else {
                completion(())
                let tempError = NSError(domain: "", code: 401, userInfo: [ NSLocalizedDescriptionKey: "Unauthorized error"])
            }
        }
    }
    
    func fetchGameListInfo(completion: @escaping (Void?) -> ()) {
        validateAccessToken(token: DBKeys.refresh_token) { [weak self] validator in
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
                            completion(())
                            print("Error decoding JSON: \(error)")
                        }
                    } else {
                        completion(())
                        print(error?.description)
                    }
                })
            } else {
                completion(())
                let tempError = NSError(domain: "", code: 401, userInfo: [ NSLocalizedDescriptionKey: "Unauthorized error"])
            }
        }
    }
    
    func addMenuItemToDB(
        _ itemsMenu: MainItemsDataParser,
        type: String,
        completion: @escaping (Void?) -> ()
    ) {
        let list = itemsMenu.data.map { $0.imagePath }
        var trueImagePath: [String] = []
        var processedCount = 0
        print(list)
        for path in list {
            getImageUrl(img: "/\(type)/" + path) { [weak self] truePath in
                processedCount += 1
                trueImagePath.append(truePath ?? "")
                if processedCount == list.count {
                    print(truePath)
                    self?.saveMainItemsToRealm(itemsMenu, trueImagePath, type: type)
                    completion(())
                }
            }
        }
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

extension DBManager {
    
//    CheatObject
    
    func fetchGTA5Codes(completion: @escaping (Void?) -> ()) {
        validateAccessToken(token: DBKeys.refresh_token) { [weak self] validator in
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
                            completion(())
                        } catch {
                            completion(())
                            print("Error decoding JSON: \(error)")
                        }
                    } else {
                        completion(())
                        print(error?.description)
                    }
                })
            } else {
                completion(())
                let tempError = NSError(domain: "", code: 401, userInfo: [ NSLocalizedDescriptionKey: "Unauthorized error"])
            }
        }
    }
    
    func fetchGTA6Codes(completion: @escaping (Void?) -> ()) {
        validateAccessToken(token: DBKeys.refresh_token) { [weak self] validator in
            guard let self = self else { return }
            
            if validator {
                self.client?.files.download(path: DBKeys.Path.gta6_modes.rawValue)
                    .response(completionHandler: { responce, error in
                    if let data = responce?.1 {
                        do {
                            let decoder = JSONDecoder()
                            let decodedData = try decoder.decode(CheatCodesGTA6Parser.self, from: data)
                            self.saveCheatItemToRealm(decodedData.GTA6, gameVersion: "GTA6")
                            completion(())
                        } catch {
                            completion(())
                            print("Error decoding JSON: \(error)")
                        }
                    } else {
                        completion(())
                        print(error?.description)
                    }
                })
            } else {
                completion(())
                let tempError = NSError(domain: "", code: 401, userInfo: [ NSLocalizedDescriptionKey: "Unauthorized error"])
            }
        }
    }
    
    func fetchGTAVCCodes(completion: @escaping (Void?) -> ()) {
        validateAccessToken(token: DBKeys.refresh_token) { [weak self] validator in
            guard let self = self else { return }
            
            if validator {
                self.client?.files.download(path: DBKeys.Path.gtavc_modes.rawValue)
                    .response(completionHandler: { responce, error in
                    if let data = responce?.1 {
                        do {
                            let decoder = JSONDecoder()
                            let decodedData = try decoder.decode(CheatCodesGTAVCParser.self, from: data)
                            self.saveCheatItemToRealm(decodedData.GTA_Vice_City, gameVersion: "GTAVC")
                            completion(())
                        } catch {
                            completion(())
                            print("Error decoding JSON: \(error)")
                        }
                    } else {
                        completion(())
                        print(error?.description)
                    }
                })
            } else {
                completion(())
                let tempError = NSError(domain: "", code: 401, userInfo: [ NSLocalizedDescriptionKey: "Unauthorized error"])
            }
        }
    }
    
    func fetchGTASACodes(completion: @escaping (Void?) -> ()) {
        validateAccessToken(token: DBKeys.refresh_token) { [weak self] validator in
            guard let self = self else { return }
            
            if validator {
                self.client?.files.download(path: DBKeys.Path.gtasa_modes.rawValue)
                    .response(completionHandler: { responce, error in
                    if let data = responce?.1 {
                        do {
                            let decoder = JSONDecoder()
                            let decodedData = try decoder.decode(CheatCodesGTASAParser.self, from: data)
                            self.saveCheatItemToRealm(decodedData.GTA_San_Andreas, gameVersion: "GTASA")
                            completion(())
                        } catch {
                            completion(())
                            print("Error decoding JSON: \(error)")
                        }
                    } else {
                        completion(())
                        print(error?.description)
                    }
                })
            } else {
                completion(())
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
    
}
