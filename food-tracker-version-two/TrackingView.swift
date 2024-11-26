//
//  TrackingView.swift
//  food-tracker-version-two
//
//  Created by Vilate Jules Knapp on 11/14/24.
//


// change to popup form, not separate page, for tracking
import SwiftUI

struct TrackingView: View {
    @State private var selectedDate = Date()
    @State private var symptomDescription = ""
    
    var body: some View {
        NavigationView {
            VStack {
                DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .padding()
                
                TextField("Symptom Description", text: $symptomDescription)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Spacer()
                
                Button(action: saveTrackingData) {
                    Text("Save")
                        .font(.headline)
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                        .padding()
                }
            }
            .padding()
            .navigationTitle("Track Symptoms")
        }
    }
    
    private func saveTrackingData() {
        print("Date: \(selectedDate), Description: \(symptomDescription)")
    }
}

struct TrackingView_Previews: PreviewProvider {
    static var previews: some View {
        TrackingView()
    }
}
