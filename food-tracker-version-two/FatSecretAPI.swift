//
//  FatSecretAPI
//  food-tracker-version-two
//
//  Created by Sophia Beebe on 11/26/24.
//


import Foundation

// Function to request an access token using client credentials
func requestAccessToken(completion: @escaping (String?) -> Void) {
    // Retrieve the client ID and client secret from the configuration
    guard let clientId = getConfigValue(for: "CLIENT_ID"),
          let clientSecret = getConfigValue(for: "CLIENT_SECRET") else {
        // Log an error if the values are not found
        print("CLIENT_ID or CLIENT_SECRET not found in Config.plist")
        completion(nil) // Complete with nil to indicate failure
        return
    }

    // URL for obtaining the access token
    let url = URL(string: "https://oauth.fatsecret.com/connect/token")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST" // HTTP POST request
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type") // Set the content type header

    // Set the request body with required parameters
    let body = "grant_type=client_credentials&client_id=\(clientId)&client_secret=\(clientSecret)&scope=basic"
    request.httpBody = body.data(using: .utf8)

    // Create a data task to send the request
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        // Handle errors in the response
        guard let data = data, error == nil else {
            print("Error requesting access token: \(error?.localizedDescription ?? "Unknown error")")
            completion(nil) // Complete with nil to indicate failure
            return
        }

        // Parse the JSON response to extract the access token
        if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
           let token = json["access_token"] as? String {
            completion(token) // Pass the token to the completion handler
        } else {
            print("Failed to parse access token response")
            completion(nil) // Complete with nil to indicate failure
        }
    }
    task.resume() // Start the request
}

// Function to search for foods based on a keyword
func apiSearchFoods(keyword: String, accessToken: String, completion: @escaping (Data?) -> Void) {
    // Construct the URL for the API endpoint
    guard let url = URL(string: "https://platform.fatsecret.com/rest/server.api") else {
        print("Invalid URL for search")
        completion(nil) // Complete with nil to indicate failure
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST" // HTTP POST request
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type") // Content type for form-encoded data
    request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization") // Authorization header with the bearer token

    // Set the body parameters for the search
    let bodyString = "method=foods.search&search_expression=\(keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&format=json"
    request.httpBody = bodyString.data(using: .utf8)

    // Create a data task to send the request
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            // Handle errors in the response
            print("Error searching for foods: \(error.localizedDescription)")
            completion(nil) // Complete with nil to indicate failure
            return
        }
        
        // Debugging: Print the response for analysis
        if let data = data, let debugResponse = String(data: data, encoding: .utf8) {
            print("Foods Search Response:\n\(debugResponse)")
        }
        
        completion(data) // Pass the response data to the completion handler
    }
    task.resume() // Start the request
}

// Function to fetch detailed information about a specific food item by ID
func getFoodById(foodId: Int, accessToken: String, completion: @escaping (Data?) -> Void) {
    // Construct the URL for the API endpoint
    guard let url = URL(string: "https://platform.fatsecret.com/rest/server.api") else {
        print("Invalid URL for getFoodById")
        completion(nil) // Complete with nil to indicate failure
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST" // HTTP POST request
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type") // Content type for form-encoded data
    request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization") // Authorization header with the bearer token

    // Set the body parameters to specify the method and food ID
    let bodyString = "method=food.get.v4&food_id=\(foodId)&format=json"
    request.httpBody = bodyString.data(using: .utf8)

    // Create a data task to send the request
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            // Handle errors in the response
            print("Error fetching food by ID: \(error.localizedDescription)")
            completion(nil) // Complete with nil to indicate failure
            return
        }
        
        // Debugging: Print the response for analysis
        if let data = data, let debugResponse = String(data: data, encoding: .utf8) {
            print("Food Detail Response:\n\(debugResponse)")
        }

        completion(data) // Pass the response data to the completion handler
    }
    task.resume() // Start the request
}
