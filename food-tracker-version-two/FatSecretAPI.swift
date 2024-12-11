import Foundation

func requestAccessToken(completion: @escaping (String?) -> Void) {
    guard let clientId = getConfigValue(for: "CLIENT_ID"),
          let clientSecret = getConfigValue(for: "CLIENT_SECRET") else {
        print("CLIENT_ID or CLIENT_SECRET not found in Config.plist")
        completion(nil)
        return
    }

    let url = URL(string: "https://oauth.fatsecret.com/connect/token")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

    let body = "grant_type=client_credentials&client_id=\(clientId)&client_secret=\(clientSecret)&scope=basic"
    request.httpBody = body.data(using: .utf8)

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data, error == nil else {
            print("Error requesting access token: \(error?.localizedDescription ?? "Unknown error")")
            completion(nil)
            return
        }

        if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
           let token = json["access_token"] as? String {
            completion(token)
        } else {
            print("Failed to parse access token response")
            completion(nil)
        }
    }
    task.resume()
}

func apiSearchFoods(keyword: String, accessToken: String, completion: @escaping (Data?) -> Void) {
    guard let url = URL(string: "https://platform.fatsecret.com/rest/server.api") else {
        print("Invalid URL for search")
        completion(nil)
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    // Use form-encoded since we send parameters like method=foods.search
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

    let bodyString = "method=foods.search&search_expression=\(keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&format=json"
    request.httpBody = bodyString.data(using: .utf8)

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("Error searching for foods: \(error.localizedDescription)")
            completion(nil)
            return
        }
        
        // Print the response for debugging
        if let data = data, let debugResponse = String(data: data, encoding: .utf8) {
            print("Foods Search Response:\n\(debugResponse)")
        }
        
        completion(data)
    }
    task.resume()
}

func getFoodById(foodId: Int, accessToken: String, completion: @escaping (Data?) -> Void) {
    guard let url = URL(string: "https://platform.fatsecret.com/rest/server.api") else {
        print("Invalid URL for getFoodById")
        completion(nil)
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

    let bodyString = "method=food.get.v4&food_id=\(foodId)&format=json"
    request.httpBody = bodyString.data(using: .utf8)

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("Error fetching food by ID: \(error.localizedDescription)")
            completion(nil)
            return
        }
        
        // Print response for debugging
        if let data = data, let debugResponse = String(data: data, encoding: .utf8) {
            print("Food Detail Response:\n\(debugResponse)")
        }

        completion(data)
    }
    task.resume()
}
