//
//  LoginViewWrapper.swift
//  food-tracker-version-two
//
//  Created by Kaylee Wright on 11/19/24.
//

import SwiftUI
import UIKit

// View for authenticator and login/logout
struct LoginViewWrapper: UIViewControllerRepresentable {
    // inject authmanager environment to manage authentication state
    @EnvironmentObject var authManager: AuthManager

    // loginview
    func makeUIViewController(context: Context) -> LoginView {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        // crash app if loginview not found
        guard let loginVC = storyboard.instantiateViewController(identifier: "LoginView") as? LoginView else {
            fatalError("LoginView not found in Main storyboard")
        }
        loginVC.authManager = authManager
        return loginVC
    }

    func updateUIViewController(_ uiViewController: LoginView, context: Context) {
        // No update needed
    }
}
