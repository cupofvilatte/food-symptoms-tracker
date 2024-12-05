//
//  AuthManager.swift
//  food-tracker-version-two
//
//  Created by Kaylee Wright on 11/19/24.
//

import Foundation
import Auth0

class AuthManager: ObservableObject {
    @Published var isAuthenticated = false
    
    func login(completion: @escaping () -> Void) {
        Auth0
            .webAuth()
            .start {result in
                switch result {
                case .success(let credentials):
                    DispatchQueue.main.async {
                        self.isAuthenticated = true
                        completion()
                    }
                case .failure(let error):
                    print("Login failed: \(error)")
                }
            }
    }
    
    func logout() {
        Auth0
            .webAuth()
            .clearSession { result in
                DispatchQueue.main.async {
                    self.isAuthenticated = false
                }
            }
    }
}
