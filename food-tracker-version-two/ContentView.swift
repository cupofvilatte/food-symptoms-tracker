//
//  ContentView.swift
//  food-tracker-version-two
//
//  Created by Vilate Jules Knapp on 11/14/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
            // tabs on the bottom to click to different pages
            TabView {
                MainPageView()
                    .tabItem {
                        // home icon
                        Image(systemName: "house.fill")
                        Text("Main")
                    }
                
                CalendarView()
                    .tabItem {
                        // calendar icon
                        Image(systemName: "calendar")
                        Text("Calendar")
                    }
                
                WellnessView()
                    .tabItem {
                        // heart icon
                        Image(systemName: "heart.fill")
                        Text("Wellness")
                    }
                
                ContactUsView()
                    .tabItem {
                        // phone icon
                        Image(systemName: "phone.fill")
                        Text("Contact Us")
                    }
            }
        }
}

#Preview {
    ContentView()
}
