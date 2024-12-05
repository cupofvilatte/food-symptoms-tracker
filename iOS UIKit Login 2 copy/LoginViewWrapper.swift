//
//  LoginViewWrapper.swift
//  food-tracker-version-two
//
//  Created by Kaylee Wright on 11/19/24.
//

import SwiftUI
import UIKit

struct LoginViewWrapper: UIViewControllerRepresentable {
    @EnvironmentObject var authManager: AuthManager

    func makeUIViewController(context: Context) -> LoginView {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
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
