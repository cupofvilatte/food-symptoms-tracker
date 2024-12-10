//
//  TrackingView.swift
//  food-tracker-version-two
//
//  Created by Vilate Jules Knapp on 11/14/24.
//


// change to popup form, not separate page, for tracking
import SwiftUI

// user interface for tracking symptoms and food intake
struct TrackingView: View {
    // variables for date, symptom, and food
    @State private var selectedDate = Date()
    @State private var symptomDescription = ""
    @State private var foodEnter = ""
    
    var body: some View {
        NavigationView {
            VStack {
                // allow choice of date based on ui
                DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle()) // graphical style for date picker
                    .padding()
                
                // input for symptoms
                TextField("Symptom Description", text: $symptomDescription)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                // input for food
                TextField("Enter the Food You Ate", text: $foodEnter)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Spacer()
                
                // button to save. made to connect to firebase for data storage
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
    
    // to be updated. to track data when button is pressed
    private func saveTrackingData() {
        print("Date: \(selectedDate), Description: \(symptomDescription)")
    }
}

struct TrackingView_Previews: PreviewProvider {
    static var previews: some View {
        TrackingView()
    }
}
