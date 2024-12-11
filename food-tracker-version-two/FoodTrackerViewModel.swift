//
//  FoodTrackerViewModel.Swift
//  food-tracker-version-two
//
//  Created by Sophia Beebe on 11/26/24.
//


import Foundation

// Represents a basic food item with a unique identifier, name, food ID, and description.
struct FoodItem: Identifiable {
    let id = UUID() // Unique identifier for each food item.
    let name: String // Name of the food item (e.g., "Cheddar Cheese").
    let foodId: Int // ID of the food item from the API.
    let description: String // A brief description of the food item (e.g., nutritional info).
}

// Represents detailed information about a specific food item, including its servings.
struct FoodDetail: Identifiable {
    let id = UUID() // Unique identifier for each food detail.
    let name: String // Name of the food item (e.g., "Cheddar Cheese").
    let servings: [ServingDetail] // A list of serving options for the food.
}

// Represents details about a specific serving size of a food item.
struct ServingDetail: Identifiable, Hashable {
    let id = UUID() // Unique identifier for each serving detail.
    let description: String // Description of the serving (e.g., "1 slice").
    let calories: String // Calories in the serving.
    let carbohydrate: String // Carbohydrate content in the serving.
    let protein: String // Protein content in the serving.
    let fat: String // Fat content in the serving.
    let saturatedFat: String // Saturated fat content.
    let polyunsaturatedFat: String // Polyunsaturated fat content.
    let monounsaturatedFat: String // Monounsaturated fat content.
    let cholesterol: String // Cholesterol content.
    let sodium: String // Sodium content.
    let potassium: String // Potassium content.
    let fiber: String // Fiber content.
    let sugar: String // Sugar content.
    let vitaminA: String // Vitamin A content.
    let vitaminC: String // Vitamin C content.
    let calcium: String // Calcium content.
    let iron: String // Iron content.
}

// ViewModel responsible for handling the food tracker logic and API interactions.
class FoodTrackerViewModel: ObservableObject {
    @Published var foodResults: [FoodItem] = [] // List of food items returned by the search.
    @Published var errorMessage: String? // Error message to display if something goes wrong.
    @Published var selectedFoodDetail: FoodDetail? // Detailed information about a selected food item.
    private var accessToken: String? // OAuth access token for API requests.

    // Initializes the ViewModel and retrieves the access token asynchronously.
    init() {
        requestAccessToken { [weak self] token in
            DispatchQueue.main.async {
                guard let self = self else { return }
                if let token = token {
                    self.accessToken = token // Store the access token for future use.
                } else {
                    self.errorMessage = "Failed to get access token." // Set error if token retrieval fails.
                }
            }
        }
    }

    // Searches for food items by keyword using the FatSecret API.
    func searchFoods(keyword: String) {
        guard let accessToken = accessToken else {
            errorMessage = "Access token not available." // Show error if token is missing.
            return
        }

        // Call the API to search for foods.
        apiSearchFoods(keyword: keyword, accessToken: accessToken) { [weak self] data in
            guard let self = self, let data = data else {
                DispatchQueue.main.async {
                    self?.errorMessage = "No data returned." // Show error if no data is received.
                }
                return
            }
            do {
                // Parse the JSON response into a list of food items.
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let foodsWrapper = json["foods"] as? [String: Any],
                   let foodsArray = foodsWrapper["food"] as? [[String: Any]] {

                    var items: [FoodItem] = []
                    for f in foodsArray {
                        if let foodName = f["food_name"] as? String,
                           let foodIdStr = f["food_id"] as? String,
                           let foodId = Int(foodIdStr),
                           let description = f["food_description"] as? String {
                            let item = FoodItem(name: foodName, foodId: foodId, description: description)
                            items.append(item) // Add the item to the results list.
                        }
                    }

                    // Update the results and clear any previous error messages.
                    DispatchQueue.main.async {
                        self.foodResults = items
                        if items.isEmpty {
                            self.errorMessage = "No results found for \"\(keyword)\"."
                        } else {
                            self.errorMessage = nil
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.errorMessage = "Failed to parse food data." // Error if parsing fails.
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to parse food data: \(error.localizedDescription)" // Catch any exceptions.
                }
            }
        }
    }

    // Fetches detailed information about a specific food item by its ID.
    func fetchFoodById(foodId: Int) {
        guard let accessToken = accessToken else {
            errorMessage = "Access token not available." // Show error if token is missing.
            return
        }

        // Call the API to get food details by ID.
        getFoodById(foodId: foodId, accessToken: accessToken) { [weak self] data in
            guard let self = self, let data = data else { return }
            do {
                // Parse the JSON response into a FoodDetail object.
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let foodDict = json["food"] as? [String: Any],
                   let foodName = foodDict["food_name"] as? String,
                   let servingsDict = foodDict["servings"] as? [String: Any] {

                    var servingsArray: [[String: Any]] = []
                    if let multiple = servingsDict["serving"] as? [[String: Any]] {
                        servingsArray = multiple
                    } else if let single = servingsDict["serving"] as? [String: Any] {
                        servingsArray = [single]
                    }

                    let servings = servingsArray.map { s -> ServingDetail in
                        ServingDetail(
                            description: s["serving_description"] as? String ?? "N/A",
                            calories: s["calories"] as? String ?? "N/A",
                            carbohydrate: s["carbohydrate"] as? String ?? "N/A",
                            protein: s["protein"] as? String ?? "N/A",
                            fat: s["fat"] as? String ?? "N/A",
                            saturatedFat: s["saturated_fat"] as? String ?? "N/A",
                            polyunsaturatedFat: s["polyunsaturated_fat"] as? String ?? "N/A",
                            monounsaturatedFat: s["monounsaturated_fat"] as? String ?? "N/A",
                            cholesterol: s["cholesterol"] as? String ?? "N/A",
                            sodium: s["sodium"] as? String ?? "N/A",
                            potassium: s["potassium"] as? String ?? "N/A",
                            fiber: s["fiber"] as? String ?? "N/A",
                            sugar: s["sugar"] as? String ?? "N/A",
                            vitaminA: s["vitamin_a"] as? String ?? "N/A",
                            vitaminC: s["vitamin_c"] as? String ?? "N/A",
                            calcium: s["calcium"] as? String ?? "N/A",
                            iron: s["iron"] as? String ?? "N/A"
                        )
                    }

                    // Create a FoodDetail object and update the ViewModel.
                    let detail = FoodDetail(name: foodName, servings: servings)
                    DispatchQueue.main.async {
                        self.selectedFoodDetail = detail
                    }
                } else {
                    print("Failed to parse food by ID response") // Log error for debugging.
                }
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)") // Catch parsing errors.
            }
        }
    }
}

