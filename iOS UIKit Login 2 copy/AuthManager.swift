//
//  AuthManager.swift
//  food-tracker-version-two
//
//  Created by Kaylee Wright on 11/19/24.
//

import Foundation
import Auth0

// Handles user authentication
// Login and logout functionality
class AuthManager: ObservableObject {
    // default as not authenticated
    @Published var isAuthenticated = false
    
    // login process. if login is successful, updates authentication and logs in
    func login(completion: @escaping () -> Void) {
        Auth0
            .webAuth()
            .start {result in
                switch result {
                case .success(let credentials):
                    // successful login
                    DispatchQueue.main.async {
                        self.isAuthenticated = true
                        completion()
                    }
                case .failure(let error):
                    // failed login
                    print("Login failed: \(error)")
                }
            }
    }
    
    // logout user using Auth0. updates authentication state to false
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
