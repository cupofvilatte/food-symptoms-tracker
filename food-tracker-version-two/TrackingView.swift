//
//  TrackingView.swift
//  food-tracker-version-two
//
//  Created by Vilate Jules- redid by Sophia Beebe on 11/14/24.
//

//  Edited and redid by Sophia Beebe on 11/26//24


import SwiftUI

struct TrackingView: View {
    // State properties to hold data related to the tracking view
    @State private var selectedDate = Date() // Tracks the date selected by the user. //Vilates Code
    @State private var symptomDescription = "" // Holds the symptom description input by the user. //Vilates Code
    @State private var searchKeyword = "" // Tracks the keyword entered in the search bar.
    @State private var selectedFood: FoodItem? = nil // Holds the selected food item.
    @State private var selectedServing: ServingDetail? = nil // Holds the selected serving size for the food.
    @State private var quantity: Int = 1 // Tracks the quantity of the selected serving.

    @StateObject private var viewModel = FoodTrackerViewModel() // Observable object to manage the data logic.
    @State private var showSavedDetailView = false // Controls navigation to the saved details view.
    @State private var showSearchResults = false // Toggles the display of the search results sheet.

    @State private var savedDate: Date = Date() // Holds the saved date.
    @State private var savedSymptom: String = "" // Holds the saved symptom description.
    @State private var savedDetail: FoodDetail? = nil // Holds the saved food detail.
    @State private var savedServing: ServingDetail? = nil // Holds the saved serving detail.
    @State private var savedQuantity: Int = 1 // Holds the saved quantity.

    var body: some View { //Vilates Code
        // NavigationView wraps the main content, enabling navigation to other views.
        NavigationView {
            VStack(spacing: 16) {
                // Section for selecting the date.
                datePickerSection // Vilates Code
                
                // Section for entering symptom details.
                symptomSection // Vilates Code
                
                // Section for the search bar to search for foods.
                searchBarSection
                
                // Conditional view showing serving options if a food is selected.
                if let selectedFood = selectedFood, let foodDetail = viewModel.selectedFoodDetail {
                    servingSelectionView(food: selectedFood, detail: foodDetail)
                } else {
                    // Placeholder text when no food is selected.
                    Text("Please search for and select a food.")
                        .foregroundColor(.secondary)
                        .padding()
                }
                
                Spacer() // Pushes the content upwards.

                // Save button to save the tracking data.
                saveButton
                
                // Hidden navigation link to transition to the saved details view.
                navigationLinkToSavedDetails
            }
            .padding(.top)
            .navigationTitle("Track Symptoms") // Sets the title of the navigation bar.
            .sheet(isPresented: $showSearchResults) {
                // Displays the search results in a sheet.
                searchResultsView
            }
        }
    }
    
    // MARK: - Subviews
    
    // Date picker for selecting the tracking date. //Vilates Code
    private var datePickerSection: some View {
        DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
            .datePickerStyle(GraphicalDatePickerStyle())
            .padding(.horizontal)
    }
    
    // Text field for entering symptom descriptions.
    private var symptomSection: some View { //Vilates Code
        TextField("Symptom Description", text: $symptomDescription)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.horizontal)
    }
    
    // Search bar with a text field and a "Go" button for initiating a search.
    private var searchBarSection: some View {
        HStack {
            TextField("Search for a food...", text: $searchKeyword, onCommit: {
                startSearch() // Calls the search action when Enter is pressed.
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            
            // "Go" button for triggering a search.
            Button(action: startSearch) {
                Text("Go")
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .disabled(searchKeyword.isEmpty) // Disables the button if the search keyword is empty.
        }
        .padding(.horizontal)
    }
    
    // Displays serving options and quantity selection for the selected food.
    @ViewBuilder
    private func servingSelectionView(food: FoodItem, detail: FoodDetail) -> some View {
        Form {
            Section(header: Text("Selected Food")) {
                Text(food.name)
                    .font(.headline)
            }
            
            if detail.servings.isEmpty {
                Section {
                    Text("No serving details available.") // Shown if no serving details exist.
                }
            } else {
                Section(header: Text("Choose Serving Size")) {
                    Picker("Serving", selection: $selectedServing) {
                        ForEach(detail.servings) { serving in
                            Text(serving.description).tag(Optional(serving)) // Lists serving options.
                        }
                    }
                }
                
                // Allows the user to select the quantity of the serving.
                Section(header: Text("Quantity")) {
                    Stepper(value: $quantity, in: 1...100, step: 1) {
                        Text("\(quantity) \(quantity == 1 ? "unit" : "units")")
                    }
                }
            }
        }
        .frame(maxHeight: 300)
    }
    
    // Button for saving the tracking data.
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
    
    // Navigation link to the saved details view (hidden by default).
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
    
    // Displays the search results in a list format.
    private var searchResultsView: some View {
        VStack {
            Text("Search Results for \"\(searchKeyword)\"")
                .font(.headline)
                .padding()
            
            // Shows error message if an error occurred.
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            
            // Shows a placeholder if no results are available yet.
            if viewModel.foodResults.isEmpty && viewModel.errorMessage == nil {
                Spacer()
                Text("No results yet. Try searching again.")
                    .foregroundColor(.secondary)
                Spacer()
            } else {
                // Displays the search results in a list.
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
    
    // Starts the search by calling the ViewModel's search method.
    private func startSearch() {
        guard !searchKeyword.isEmpty else { return }
        viewModel.searchFoods(keyword: searchKeyword)
        showSearchResults = true
    }

    // Saves the current tracking data. //Vilates Code
    private func saveTrackingData() {
        savedDate = selectedDate
        savedSymptom = symptomDescription
        savedDetail = viewModel.selectedFoodDetail
        savedServing = selectedServing
        savedQuantity = quantity
        showSavedDetailView = true
    }
}
