//
//  AuthManager.swift
//  food-tracker-version-two
//
//  Created by Kaylee Wright on 11/19/24.
//

import Foundation
import Auth0

struct Auth0User {
    let id: String
    let name: String
    let email: String
}

class AuthManager: ObservableObject {
    @Published var isAuthenticated = false
    @Published var accessToken: String = ""
    @Published var auth0User: Auth0User? = nil
    
    func login(completion: @escaping () -> Void) {
        Auth0
            .webAuth()
            .start {result in
                switch result {
                case .success(let credentials):
                    self.fetchUserInfo(accessToken: credentials.accessToken)
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
                    self.auth0User = nil
                }
            }
    }
    func fetchUserInfo(accessToken: String) {
        guard let url = URL(string: "https://dev-sk760okn28ajqt83.us.auth0.com/userinfo") else {
            print("Invalid URL for userinfo endpoint.")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching user info: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("No data received.")
                return
            }

            do {
                if let userInfo = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    DispatchQueue.main.async {
                        self.auth0User = Auth0User(
                            id: userInfo["sub"] as? String ?? "",
                            name: userInfo["name"] as? String ?? "",
                            email: userInfo["email"] as? String ?? ""
                        )
                        print("User info fetched successfully: \(self.auth0User!)")
                    }
                }
            } catch {
                print("Failed to decode user info: \(error.localizedDescription)")
            }
        }
        task.resume()
    }

}
