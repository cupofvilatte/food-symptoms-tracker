//
//  CalendarView.swift
//  food-tracker-version-two
//
//  Created by Vilate Jules Knapp on 11/14/24.
//

import SwiftUI

struct CalendarView: View {
    @State private var currentDate = Date()
    private var calendar = Calendar.current
    private let daysOfWeek: [String] = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    var body: some View {
        VStack {
            Text(currentMonthAndYear())
                .font(.title)
                .padding()
            HStack {
                ForEach(daysOfWeek, id: \.self) { day in
                    Text(day)
                        .font(.headline)
                        .frame(minWidth: 0, maxWidth: .infinity)
                }
            }
            
            let daysInMonth = getDaysInMonth()
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(minimum: 40, maximum:50)), count: 7), spacing: 10) {
                ForEach(daysInMonth, id: \.self) { day in
                    Text(day == 0 ? "" : "\(day)")
                        .font(.body)
                        .padding(5)
                        .frame(maxWidth: .infinity, maxHeight: 40)
                        .background(isToday(day: day) ? Color.blue : Color.clear)
                        .cornerRadius(8)
                        .foregroundStyle(isToday(day: day) ? .white : .black)
                }
            }
            .padding()
            
            Spacer()
            
            NavigationLink(destination: TrackingView()) {
                Image(systemName: "plus")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .padding()
                    .background(Color.blue)
                    .foregroundStyle(.white)
                    .clipShape(Circle())
            }
            .padding(.bottom, 20)
        }
        .padding()
    }
    
    
    private func currentMonthAndYear() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: currentDate)
    }
    
    private func getDaysInMonth() -> [Int] {
        guard let range = calendar.range(of: .day, in: .month, for: currentDate) else { return [] }
        let firstWeekday = calendar.component(.weekday, from: calendar.startOfMonth(for: currentDate))
        let paddingDays = Array(repeating: 0, count: firstWeekday - 1)
        return paddingDays + Array(range)
    }
    
    private func isToday(day: Int) -> Bool {
        let today = calendar.component(.day, from: Date())
        return day == today
    }
}

extension Calendar {
    func startOfMonth(for date: Date) -> Date {
        let components = dateComponents([.year, .month], from: date)
        return self.date(from: components) ?? date
    }
}
