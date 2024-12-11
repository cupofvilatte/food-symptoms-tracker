import Foundation

struct FoodItem: Identifiable {
    let id = UUID()
    let name: String
    let foodId: Int
    let description: String
}

struct FoodDetail: Identifiable {
    let id = UUID()
    let name: String
    let servings: [ServingDetail]
}

struct ServingDetail: Identifiable, Hashable {
    let id = UUID()
    let description: String
    let calories: String
    let carbohydrate: String
    let protein: String
    let fat: String
    let saturatedFat: String
    let polyunsaturatedFat: String
    let monounsaturatedFat: String
    let cholesterol: String
    let sodium: String
    let potassium: String
    let fiber: String
    let sugar: String
    let vitaminA: String
    let vitaminC: String
    let calcium: String
    let iron: String
}

class FoodTrackerViewModel: ObservableObject {
    @Published var foodResults: [FoodItem] = []
    @Published var errorMessage: String?
    @Published var selectedFoodDetail: FoodDetail?
    private var accessToken: String?

    init() {
        requestAccessToken { [weak self] token in
            DispatchQueue.main.async {
                guard let self = self else { return }
                if let token = token {
                    self.accessToken = token
                } else {
                    self.errorMessage = "Failed to get access token."
                }
            }
        }
    }

    func searchFoods(keyword: String) {
        guard let accessToken = accessToken else {
            errorMessage = "Access token not available."
            return
        }

        apiSearchFoods(keyword: keyword, accessToken: accessToken) { [weak self] data in
            guard let self = self, let data = data else {
                DispatchQueue.main.async {
                    self?.errorMessage = "No data returned."
                }
                return
            }
            do {
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
                            items.append(item)
                        }
                    }

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
                        self.errorMessage = "Failed to parse food data."
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to parse food data: \(error.localizedDescription)"
                }
            }
        }
    }

    func fetchFoodById(foodId: Int) {
        guard let accessToken = accessToken else {
            errorMessage = "Access token not available."
            return
        }

        getFoodById(foodId: foodId, accessToken: accessToken) { [weak self] data in
            guard let self = self, let data = data else { return }
            do {
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

                    let detail = FoodDetail(name: foodName, servings: servings)
                    DispatchQueue.main.async {
                        self.selectedFoodDetail = detail
                    }
                } else {
                    print("Failed to parse food by ID response")
                }
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
            }
        }
    }
}
