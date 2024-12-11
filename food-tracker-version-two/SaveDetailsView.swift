import SwiftUI

struct SavedDetailsView: View {
    let date: Date
    let symptom: String
    let detail: FoodDetail?
    let selectedServing: ServingDetail?
    let quantity: Int

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Saved Entry")
                    .font(.largeTitle)
                    .padding(.top)

                Text("Date: \(formattedDate(date))")
                    .font(.headline)
                Text("Symptom: \(symptom.isEmpty ? "None" : symptom)")
                    .font(.headline)

                if let d = detail {
                    Text("Food: \(d.name)")
                        .font(.title2)
                        .padding(.top)

                    if let serving = selectedServing {
                        Text("Selected Serving: \(serving.description)")
                            .font(.subheadline)
                            .padding(.top)
                        Text("Quantity: \(quantity)")
                            .font(.subheadline)
                    }

                    if d.servings.isEmpty {
                        Text("No serving details available.")
                    } else {
                        ForEach(d.servings) { serving in
                            VStack(alignment: .leading, spacing: 5) {
                                Text(serving.description).font(.headline)
                                Text("Calories: \(serving.calories)")
                                Text("Carbs: \(serving.carbohydrate)")
                                Text("Protein: \(serving.protein)")
                                Text("Fat: \(serving.fat)")
                            }
                            .padding(.vertical)
                        }
                    }
                } else {
                    Text("No food details were selected.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Saved Details")
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
