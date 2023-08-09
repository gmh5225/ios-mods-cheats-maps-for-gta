

import Foundation
import SwiftyDropbox
import CoreData

protocol DropBoxManagerDelegate : AnyObject {
    func currentProgressOperation(progress : Progress)
    func isReadyAllContent()
}

final class DBManager : NSObject {
    
    // MARK: - Private properties

    private let defaults = UserDefaults.standard
    private var isReadyContent : Bool = false
    
    let notShared: Void = { () -> Void in
        let fruits = ["apple", "banana", "cherry"]
        for _ in fruits {
            print("")
        }
    }()
    
    // MARK: - Public properties

    static let shared = DBManager()
    var client: DropboxClient?
    weak var delegate: DropBoxManagerDelegate?
    
    
    // MARK: - For CoreData
    
//    var persistentContainer = CoreDataManager.shared.persistentContainer
    
    // MARK: - Public

    func setupDropBox() {
            clearAllThings()
            
            guard let refresh = defaults.value(forKey: DBKeys.RefreshTokenSaveVar) as? String else {
                print("start resetting token operation")
                reshreshToken(code: DBKeys.token) { [weak self] refresh_token in
                    guard let self = self else { return }
                    if let rToken = refresh_token {
                        print(rToken)
                        self.defaults.setValue(rToken, forKey: DBKeys.RefreshTokenSaveVar)
                        self.validateAccessToken(token: DBKeys.refresh_token) { validator2 in
                                       
                                    }
                    }
                }
                self.validateAccessToken(token: DBKeys.refresh_token) { validator2 in
                                
                            }
                
                return
            }
            
            print("\(refresh) add to ---> refresh_token")
            validateAccessToken(token: refresh) { [weak self] validator in
                guard let self = self else { return }
                self.fetchData(validate: validator)
            }
        }
    
    func fetchNutritions(_ completion: @escaping (Error?) -> Void) {
        validateAccessToken(token: DBKeys.refresh_token) { [weak self] validator in
                guard let self = self else { return }
                if validator {
                    self.featchNutritionItems(completion)
                } else {
                    let tempError = NSError(domain: "", code: 401, userInfo: [ NSLocalizedDescriptionKey: "Unauthorized error"])
                    completion(tempError)
                }
            }
        }
    
    func fetchGTA5Modes() {
        validateAccessToken(token: DBKeys.refresh_token) { [weak self] validator in
            guard let self = self else { return }
            
            if validator {
                self.client?.files.download(path:  DBKeys.Path.gta5_modes.rawValue).response(completionHandler: { responce, error in
                    if let responce = responce {
                        print("responce.1")
        //                completion(responce.1)
                    } else {
                        print(error?.description)

                    }
                })
            } else {
                let tempError = NSError(domain: "", code: 401, userInfo: [ NSLocalizedDescriptionKey: "Unauthorized error"])
//                completion(tempError)
            }
        }

    }
    
    func getImageUrl(img: String, completion: @escaping (String?) -> ()){
            validateAccessToken(token: DBKeys.refresh_token) { [weak self] isValid in
                guard let self = self else { return }
                self.client?.files.getTemporaryLink(path: "/\(img)").response(completionHandler: { responce, error in
                    if let link = responce {
                        completion(link.link)
                    } else {
                        completion(nil)
                    }
                })
            }
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
    
//    func saveDayInfo(name: String, categories: [NutritionCategory]) {
//
//        let context = persistentContainer.viewContext
//
//        let point = DayDataModel(context: context)
//        point.name = name
//
//        var categoriesArray = [CategoryDataModel]()
//
//        for (index, categ) in categories.enumerated() {
//            print(categ.name)
//            let categToSave = CategoryDataModel(context: context)
//
//            categToSave.name = categ.name
//            categToSave.day = point
//            categToSave.displayIndex = Int64(index)
//
//            var recipeArray = [RecipeDataModel]()
//
//            for recipe in categ.recipes {
//                let recipeToSave = RecipeDataModel(context: context)
//
//                recipeToSave.howToCook = recipe.howToCook
//                recipeToSave.imagePath = recipe.imagePath
//                recipeToSave.ingredients = recipe.ingredients
//                recipeToSave.kCal = recipe.kCal
//                recipeToSave.name = recipe.name
//                recipeToSave.other = recipe.other
//                recipeToSave.time = recipe.time
//                recipeToSave.done = false
//                recipeToSave.category = categToSave
//
//                recipeArray.append(recipeToSave)
//            }
//
//            var recipeSet = NSSet(array: recipeArray)
//
//            categToSave.recipes = recipeSet
//
//            categoriesArray.append(categToSave)
//        }
//
//        let categorySet = NSSet(array: categoriesArray) // Convert array to NSSet
//        point.categories = categorySet
//
//        do {
//            try context.save()
//        } catch let error {
//            print("Error saving day info: \(error.localizedDescription)")
//        }
//    }
    
    
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
    
    func fetchData(validate : Bool) {
         if validate {
            print("token valid")
            if defaults.value(forKey: "dataDidLoaded") == nil || (defaults.value(forKey: "dataDidLoaded") != nil) == true {
                featchNutritionItems { error in
                }
                

            } else {
                print("data in database")
            }
        } else {
            print("token has expired")
        }
    }
    
    func featchNutritionItems(_ completion: @escaping (Error?) -> Void)  {
        client?.files.download(path: DBKeys.Path.gta5_modes.rawValue).response(completionHandler: { [weak self] response, error in
            guard let self = self else { return }
//            if let response = response {
//                let fileContents = response.1
//
//                if let response = try? JSONDecoder().decode(DBNutritionResponce.self, from: fileContents) {
//                    let nutrition = response.nutritions.first
//                    print(nutrition)
//
//                    let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "DayDataModel")
//                    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
//
//                    do {
//
//                        try self.persistentContainer.viewContext.execute(deleteRequest)
//                        try self.persistentContainer.viewContext.save()
//                        print("Removed all elements")
//                    } catch let error {
//                        self.persistentContainer.viewContext.rollback()
//                        print("Error: \(error.localizedDescription)")
//                    }
//
//
//                    if let days = nutrition?.days {
//                        for day in days {
//                            self.saveDayInfo(name: day.name, categories: day.categories)
//                        }
//                    }
//
//                    UserDefaults.standard.set(true, forKey: "dietexist")
//                    DispatchQueue.main.async { completion(nil) }
//
//                } else {
//                    let tempError = NSError(domain: "", code: 500, userInfo: [ NSLocalizedDescriptionKey: "Bad response"])
//                    DispatchQueue.main.async { completion(tempError) }
//                }
//            }
//
//            if let error = error {
//                print(error)
//                let tempError = NSError(domain: "", code: 500, userInfo: [ NSLocalizedDescriptionKey: "Internal service error"])
//                DispatchQueue.main.async { completion(tempError) }
//            }
//
        })
        .progress({ progress in
            print("Downloading: ",progress)
        })
    }
    
//
//    func fetchHabbits(path: String, type: Decodable.Type, completion: @escaping (Data?) -> Void) {
//        client?.files.download(path: path).response(completionHandler: { response, error in
//            if let response = response {
//                let fileContents = response.1
//                DispatchQueue.main.async { completion(fileContents) }
//            }
//
//            if let error = error {
//                print(error)
//                DispatchQueue.main.async { completion(nil) }
//            }
//
//        })
//        .progress({ progress in
//            print("Downloading: ",progress)
//        })
//    }
    
    func validateAccessToken(token : String,completion: @escaping(Bool)->()) {
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



