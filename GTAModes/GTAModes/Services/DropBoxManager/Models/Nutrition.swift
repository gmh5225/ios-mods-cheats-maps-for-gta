import Foundation

struct DBNutritionResponce: Codable {
    
    private enum CodingKeys : String, CodingKey {
        case nutritions = "mfbvo5k_list"
    }
    
    var nutritions: [Nutrition]
}

struct Nutrition: Codable {
    var days: [NutritionDay]
}

struct NutritionDay: Codable {
    
    private enum CodingKeys : String, CodingKey {
        case name = "mfbvo5kd9",
        categories = "categories"
    }
    
    var name: String
    var categories: [NutritionCategory]
}

struct NutritionCategory: Codable {
    
    private enum CodingKeys : String, CodingKey {
        case name = "mfbvo5kt3"
        case recipes = "asdasdasdasda"
    }
    
    var name: String
    var recipes: [Recipe]
}

struct Recipe: Codable {
    
    private enum CodingKeys : String, CodingKey {
        case name = "mfbvo5kd4",
             time = "mfbvo5kd5",
             kCal = "mfbvo5kd6",
             imagePath = "mfbvo5kf2", 
             ingredients = "mfbvo5kd7",
             other = "mfbvo5kd8",
             howToCook = "mfbvo5ki1"
    }
    
    var name: String //Creamy mushrooms on toast
    var time: String //10 min
    var kCal: String //187 kcal
    var ingredients: String //Ingredients\n 1 slice wholemeal bread\n 1 ½ tbsp light cream cheese\n 1 tsp rapeseed oil\n
    var imagePath: String //Recipes_images/Creamy-Mushroom-Toast.jpg
    var howToCook: String //STEP 1\n Toast the bread\n STEP 2\n Meanwhile. Stir well until coated. Tip onto the toast and top with chives.
    var other: String?
}
