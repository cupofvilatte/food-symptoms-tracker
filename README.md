# food-symptoms-tracker


# Food Sensitivity and Symptom Tracker

## Overview
This iOS application helps users track symptoms in relation to their food intake. The goal is to assist users in identifying potential food sensitivities or intolerances, whether they are caused by specific foods or food additives. The app will allow users to log the time and type of food consumed, as well as the symptoms experienced, to help them identify patterns or correlations over time.

### Key Features:
- **Food & Symptom Tracking**: Users can log the foods they eat and the symptoms they experience, along with timestamps for both.
- **Correlation Analysis**: The app will help users identify if there’s a potential link between the time they consumed a certain food and when they experienced a symptom.
- **FatSecret Platform API Integration**: Users will be able to search and log foods from the FatSecret API database.
- **User Authentication**: A log-in page will allow users to create an account and save their data securely.
- **Homepage**: A user-friendly homepage will provide an overview of their recent food entries and symptoms.

## Tech Stack
- **Language**: Swift
- **Platform**: iOS
- **API**: FatSecret Platform API for food data
- **Database**: TBD (to store user logs, foods, and symptoms)

## Installation
1. Clone the repository:
    ```
    git clone https://github.com/cupofvilatte/food-sensitivity-tracker.git
    ```
2. Open the project in Xcode:
    ```
    cd food-sensitivity-tracker
    open FoodSensitivityTracker.xcodeproj
    ```

3. Run the project on the simulator or your iOS device.

## Usage
1. **Sign Up/Login**: Create an account or log in.
2. **Add Food Entries**: Search for food using the FatSecret API or scan barcodes (if available) to quickly log foods.
3. **Log Symptoms**: Enter any symptoms you experience and the time they occurred.
4. **Analyze Correlations**: View potential correlations between your food intake and symptoms based on the times logged.

## Future Improvements
- Enhanced correlation algorithm for more accurate insights.
- Visualization tools for food and symptom patterns.
- Push notifications for reminding users to log symptoms.
- **Barcode Scanning**: We are experimenting with implementing barcode scanning to allow users to quickly add foods by scanning product barcodes.
- **Period Tracker** for more symptom correctness 
  
## Contributing
We welcome contributions! Feel free to submit a pull request or open an issue for any suggestions.

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

Let me know if you'd like to modify or expand any sections!
