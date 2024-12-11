//
//  SaveDetailsView.swift
//  food-tracker-version-two
//
//  Created by Sophia Beebe on 11/26/24.
//

import SwiftUI

// View for displaying details of a saved entry including date, symptoms, food details, and serving/quantity information.
struct SavedDetailsView: View {
    // Properties passed into the view
    let date: Date // The date of the saved entry.
    let symptom: String // The symptom description associated with the entry.
    let detail: FoodDetail? // The food details, which might be nil if no food was selected.
    let selectedServing: ServingDetail? // The specific serving detail selected by the user.
    let quantity: Int // The quantity of the serving selected.

    var body: some View {
        // ScrollView to allow content to scroll vertically if it overflows the screen.
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Title for the view.
                Text("Saved Entry")
                    .font(.largeTitle) // Large title font for emphasis.
                    .padding(.top) // Adds spacing at the top of the view.

                // Display the formatted date.
                Text("Date: \(formattedDate(date))")
                    .font(.headline)

                // Display the symptom description or "None" if empty.
                Text("Symptom: \(symptom.isEmpty ? "None" : symptom)")
                    .font(.headline)

                // Check if there are food details available.
                if let d = detail {
                    // Display the name of the food.
                    Text("Food: \(d.name)")
                        .font(.title2)
                        .padding(.top)

                    // Check if a specific serving was selected.
                    if let serving = selectedServing {
                        // Display the description of the selected serving.
                        Text("Selected Serving: \(serving.description)")
                            .font(.subheadline)
                            .padding(.top)
                        // Display the quantity of the selected serving.
                        Text("Quantity: \(quantity)")
                            .font(.subheadline)
                    }

                    // If there are no serving details in the food details.
                    if d.servings.isEmpty {
                        Text("No serving details available.") // Inform the user no details are present.
                    } else {
                        // Display a list of all available servings with their nutritional details.
                        ForEach(d.servings) { serving in
                            VStack(alignment: .leading, spacing: 5) {
                                Text(serving.description).font(.headline) // Serving description.
                                Text("Calories: \(serving.calories)") // Calories in the serving.
                                Text("Carbs: \(serving.carbohydrate)") // Carbohydrates in the serving.
                                Text("Protein: \(serving.protein)") // Protein in the serving.
                                Text("Fat: \(serving.fat)") // Fat in the serving.
                            }
                            .padding(.vertical) // Vertical padding between serving entries.
                        }
                    }
                } else {
                    // Display this text if no food details were selected.
                    Text("No food details were selected.")
                        .font(.subheadline)
                        .foregroundColor(.secondary) // Secondary color for less emphasis.
                }

                Spacer() // Pushes the content upwards to leave space at the bottom.
            }
            .padding() // Adds padding around the entire VStack.
        }
        .navigationTitle("Saved Details") // Sets the navigation bar title.
    }

    // Helper function to format the date into a readable string.
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter() // Date formatter instance.
        formatter.dateStyle = .medium // Medium style for date (e.g., "Dec 11, 2024").
        return formatter.string(from: date) // Converts the date into a formatted string.
    }
}
