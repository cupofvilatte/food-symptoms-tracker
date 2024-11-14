//
//  ContentView.swift
//  food-tracker-version-two
//
//  Created by Vilate Jules Knapp on 11/14/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
            TabView {
                MainPageView()
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Main")
                    }
                
                CalendarView()
                    .tabItem {
                        Image(systemName: "calendar")
                        Text("Calendar")
                    }
                
                WellnessView()
                    .tabItem {
                        Image(systemName: "heart.fill")
                        Text("Wellness")
                    }
                
                ContactUsView()
                    .tabItem {
                        Image(systemName: "phone.fill")
                        Text("Contact Us")
                    }
            }
        }
}

#Preview {
    ContentView()
}
