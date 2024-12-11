//
//  ConfigManager.swift
//  food-tracker-version-two
//
//  Created by Sophia Beebe on 11/26/24.
//

import Foundation

func getConfigValue(for key: String) -> String? {
    if let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
       let config = NSDictionary(contentsOfFile: path) {
        return config[key] as? String
    }
    return nil
}


