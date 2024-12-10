//
//  CalendarView.swift
//  food-tracker-version-two
//
//  Created by Vilate Jules Knapp on 11/14/24.
//

import SwiftUI

// structure for calendar page
struct CalendarView: View {
    // current date saved as the actual date
    @State private var currentDate = Date()
    // by default do not show current date
    @State private var showTrackingView = false
    // current calendar
    private var calendar = Calendar.current
    // list of strings which are days of the week for calendar displaying purposes
    private let daysOfWeek: [String] = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    var body: some View {
        VStack {
            // show current month and year
            Text(currentMonthAndYear())
                .font(.title)
                .padding()
            // show the days of the week horizontally across the screen
            HStack {
                ForEach(daysOfWeek, id: \.self) { day in
                    Text(day)
                        .font(.headline)
                        .frame(minWidth: 0, maxWidth: .infinity)
                }
            }
            
            // display the days in the month as a grid
            let daysInMonth = getDaysInMonth()
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(minimum: 40, maximum:50)), count: 7), spacing: 10) {
                ForEach(daysInMonth, id: \.self) { day in
                    // show each day. days that are 0 will be empty
                    Text(day == 0 ? "" : "\(day)")
                        .font(.body)
                        .padding(5)
                        .frame(maxWidth: .infinity, maxHeight: 40)
                        // highlight current day
                        .background(isToday(day: day) ? Color.blue : Color.clear)
                        .cornerRadius(8)
                        .foregroundStyle(isToday(day: day) ? .white : .black)
                }
            }
            .padding()
            
            Spacer()
            
            // button toggles showTrackingView when clicked
            Button(action: {
                showTrackingView = true
            }) {
                // button styling
                Image(systemName: "plus")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .padding()
                    .background(Color.blue)
                    .foregroundStyle(.white)
                    .clipShape(Circle())
            }
            
            .padding(.bottom, 20)
            // when the button is clicked, the TrackingView will appear
            .sheet(isPresented: $showTrackingView) {
                TrackingView()
            }
        }
        .padding()
    }
    
    // function to format the current month and year in a string
    private func currentMonthAndYear() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: currentDate)
    }
    
    // returns number of days in a month (also padding for empty days)
    private func getDaysInMonth() -> [Int] {
        guard let range = calendar.range(of: .day, in: .month, for: currentDate) else { return [] }
        let firstWeekday = calendar.component(.weekday, from: calendar.startOfMonth(for: currentDate))
        // empty anything before the first day of the month
        let paddingDays = Array(repeating: 0, count: firstWeekday - 1)
        return paddingDays + Array(range)
    }
    
    // checks if a day is Today
    private func isToday(day: Int) -> Bool {
        let today = calendar.component(.day, from: Date())
        return day == today
    }
}

extension Calendar {
    // gives the first day of the month based on what is the given date
    // useful for quickly building calendar regardless of what is the current date or when months are clicked through
    func startOfMonth(for date: Date) -> Date {
        let components = dateComponents([.year, .month], from: date)
        return self.date(from: components) ?? date
    }
}
