//
//  food_tracker_version_twoApp.swift
//  food-tracker-version-two
//
//  Created by Vilate Jules Knapp on 11/14/24.
//

import SwiftUI

@main
struct food_tracker_version_twoApp: App {
    // allows custom behavior during app lifecycle events
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    // create instance of AuthManager
    @StateObject private var authManager = AuthManager()
    var body: some Scene {
        WindowGroup {
            // show content view if authenticated (logged in)
            if authManager.isAuthenticated {
                ContentView()
            // if not authenticated show login view
            } else {
                LoginViewWrapper()
                    .environmentObject(authManager)
            }
        }
    }
}
