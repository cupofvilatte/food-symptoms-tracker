//
//  TrackingView.swift
//  food-tracker-version-two
//
//  Created by Vilate Jules Knapp on 11/14/24.
//


// change to popup form, not separate page, for tracking
import SwiftUI
import FirebaseCore
import FirebaseFirestore

// user interface for tracking symptoms and food intake
struct TrackingView: View {
    // environment objects for authmanager and presentation mode
    @EnvironmentObject var authManager: AuthManager
    @Environment(\.presentationMode) var presentationMode
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
    
    // track data when button is pressed
    private func saveTrackingData() {
        guard let auth0User = authManager.auth0User else {
            print("User data is missing. Make sure to authenticate before saving.")
            return
        }
        
        print("Saving data for user ID: \(auth0User.id)")
        // prevents saving without adding a symptom
        guard !symptomDescription.isEmpty else {
            print("Symptom description cannot be empty.")
            return
        }
        // initiate database
        let db = Firestore.firestore()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: selectedDate)
        
        // specifies data to be saved
        let symptomData: [String: Any] = [
            "date": dateString,
            "description": symptomDescription,
            "food": foodEnter,
            "timestamp": FieldValue.serverTimestamp()
        ]
        // creates data structure
        db.collection("users")
            .document(auth0User.id)
            .collection("symptoms")
            .addDocument(data: symptomData) { error in
                if let error = error {
                    print("Error saving symptom data: \(error.localizedDescription)")
                } else {
                    print("Symptom data saved successfully.")
                    symptomDescription = ""
                    presentationMode.wrappedValue.dismiss()
                }
            }
    }
}

struct TrackingView_Previews: PreviewProvider {
    static var previews: some View {
        let mockAuthManager = AuthManager()
        mockAuthManager.auth0User = Auth0User(
            id: "sampleUserID",
            name: "Sample User",
            email: "sample@example.com"
//         , emailVerified: "true", picture: "", updatedAt: ""
        )
        return TrackingView()
            .environmentObject(mockAuthManager)
    }
}
