//

//  API-Setup-First.swift
//  food-tracker-version-two
//
//  Created by Sophia Beebe on 11/26/24.
//

import Foundation
//Where to put the API and connnect to rest of code

func fetchFood(completionHandler: @escaping ([Food]) -> Void) {
    let url = URL(string: domainUrlString + "food/")!
    
    //more code here once API is fully integrated

    
    //URL to API insert later
    let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
      if let error = error {
        print("Error with fetching Food: \(Food Not Found)")
        return
      }
        
        //error handeling

      guard let httpResponse = response as? HTTPURLResponse,
            (200...299).contains(httpResponse.statusCode) else {
        print("Error with the response, unexpected status code: \(response)")
        return
      }
        
        //rewrite this after integraded.

      if let data = data,
        let foodSummary = try? JSONDecoder().decode(foodSummary.self, from: data) {
        completionHandler(FoodSummary.results ?? [])
      }
    })
    task.resume()
  }
