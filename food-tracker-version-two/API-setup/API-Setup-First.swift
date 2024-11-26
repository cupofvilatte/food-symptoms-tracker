//

//  API-Setup-First.swift
//  food-tracker-version-two
//
//  Created by Sophia Beebe on 11/26/24.
//

import Foundation

func fetchFilms(completionHandler: @escaping ([Food]) -> Void) {
    let url = URL(string: domainUrlString + "films/")!

    let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
      if let error = error {
        print("Error with fetching Food: \(Food Not Found)")
        return
      }

      guard let httpResponse = response as? HTTPURLResponse,
            (200...299).contains(httpResponse.statusCode) else {
        print("Error with the response, unexpected status code: \(response)")
        return
      }

      if let data = data,
        let filmSummary = try? JSONDecoder().decode(FilmSummary.self, from: data) {
        completionHandler(FoodSummary.results ?? [])
      }
    })
    task.resume()
  }
