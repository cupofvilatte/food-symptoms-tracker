import SwiftUI

struct TrackingView: View {
    @State private var selectedDate = Date()
    @State private var symptomDescription = ""
    @State private var searchKeyword = ""
    @State private var selectedFood: FoodItem? = nil
    @State private var selectedServing: ServingDetail? = nil
    @State private var quantity: Int = 1 // The quantity chosen by the user
    
    @StateObject private var viewModel = FoodTrackerViewModel()
    @State private var showSavedDetailView = false
    @State private var showSearchResults = false // Controls the sheet for showing search results
    
    @State private var savedDate: Date = Date()
    @State private var savedSymptom: String = ""
    @State private var savedDetail: FoodDetail? = nil
    @State private var savedServing: ServingDetail? = nil
    @State private var savedQuantity: Int = 1

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                datePickerSection
                symptomSection
                searchBarSection
                
                if let selectedFood = selectedFood, let foodDetail = viewModel.selectedFoodDetail {
                    servingSelectionView(food: selectedFood, detail: foodDetail)
                } else {
                    Text("Please search for and select a food.")
                        .foregroundColor(.secondary)
                        .padding()
                }
                
                Spacer()
                saveButton
                navigationLinkToSavedDetails
            }
            .padding(.top)
            .navigationTitle("Track Symptoms")
            .sheet(isPresented: $showSearchResults) {
                searchResultsView
            }
        }
    }
    
    // MARK: - Subviews
    
    private var datePickerSection: some View {
        DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
            .datePickerStyle(GraphicalDatePickerStyle())
            .padding(.horizontal)
    }
    
    private var symptomSection: some View {
        TextField("Symptom Description", text: $symptomDescription)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.horizontal)
    }
    
    private var searchBarSection: some View {
        HStack {
            TextField("Search for a food...", text: $searchKeyword, onCommit: {
                startSearch()
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button(action: startSearch) {
                Text("Go")
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .disabled(searchKeyword.isEmpty)
        }
        .padding(.horizontal)
    }
    
    @ViewBuilder
    private func servingSelectionView(food: FoodItem, detail: FoodDetail) -> some View {
        Form {
            Section(header: Text("Selected Food")) {
                Text(food.name)
                    .font(.headline)
            }
            
            if detail.servings.isEmpty {
                Section {
                    Text("No serving details available.")
                }
            } else {
                Section(header: Text("Choose Serving Size")) {
                    Picker("Serving", selection: $selectedServing) {
                        ForEach(detail.servings) { serving in
                            Text(serving.description).tag(Optional(serving))
                        }
                    }
                }
                
                Section(header: Text("Quantity")) {
                    Stepper(value: $quantity, in: 1...100, step: 1) {
                        Text("\(quantity) \(quantity == 1 ? "unit" : "units")")
                    }
                }
            }
        }
        .frame(maxHeight: 300)
    }
    
    private var saveButton: some View {
        Button(action: saveTrackingData) {
            Text("Save")
                .font(.headline)
                .frame(maxWidth: .infinity, minHeight: 44)
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(Capsule())
                .padding(.horizontal)
                .padding(.bottom)
        }
    }
    
    private var navigationLinkToSavedDetails: some View {
        NavigationLink(
            destination: SavedDetailsView(
                date: savedDate,
                symptom: savedSymptom,
                detail: savedDetail,
                selectedServing: savedServing,
                quantity: savedQuantity
            ),
            isActive: $showSavedDetailView
        ) {
            EmptyView()
        }.hidden()
    }
    
    private var searchResultsView: some View {
        VStack {
            Text("Search Results for \"\(searchKeyword)\"")
                .font(.headline)
                .padding()
            
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            
            if viewModel.foodResults.isEmpty && viewModel.errorMessage == nil {
                Spacer()
                Text("No results yet. Try searching again.")
                    .foregroundColor(.secondary)
                Spacer()
            } else {
                List(viewModel.foodResults) { food in
                    Button(action: {
                        selectedFood = food
                        viewModel.fetchFoodById(foodId: food.foodId)
                        showSearchResults = false
                    }) {
                        VStack(alignment: .leading) {
                            Text(food.name)
                                .font(.headline)
                            Text(food.description)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Actions
    
    private func startSearch() {
        guard !searchKeyword.isEmpty else { return }
        viewModel.searchFoods(keyword: searchKeyword)
        showSearchResults = true
    }

    private func saveTrackingData() {
        savedDate = selectedDate
        savedSymptom = symptomDescription
        savedDetail = viewModel.selectedFoodDetail
        savedServing = selectedServing
        savedQuantity = quantity
        showSavedDetailView = true
    }
}
