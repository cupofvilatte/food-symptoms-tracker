# Food Sensitivity and Symptom Tracker

# Overview
{This iOS application helps users track symptoms in relation to their food intake. The goal is to assist users in identifying potential food sensitivities or intolerance, whether they are caused by specific foods or food additives. The app will allow users to log the time and type of food consumed, as well as the symptoms experienced, to help them identify patterns or correlations over time.}

# Key Features:
- **Food & Symptom Tracking**: Users can log the foods they eat and the symptoms they experience, along with timestamps for both.
- **Correlation Analysis**: The app will help users identify if there’s a potential link between the time they consumed a certain food and when they experienced a symptom.
- **FatSecret Platform API Integration**: Users will be able to search and log foods from the FatSecret API database.
- **User Authentication**: A log-in page will allow users to create an account and save their data securely.
- **Homepage**: A user-friendly homepage will provide an overview of their recent food entries and symptoms.

# Usage
{   1. **Sign Up/Login**: Create an account or log in.
    2. **Review Helpful Articles**: Explore new recipes, wellness hacks, and more on the homepage.
    3. **Add Food Entries**: Search for food using the FatSecret API to quickly log foods.
    4. **Log Symptoms**: Enter any symptoms you experience and the time they occurred.
    5. **Analyze Correlations**: View potential correlations between your food intake and symptoms based on the times logged.}

# Installation
{   1. Clone the repository:
    ```
    git clone https://github.com/cupofvilatte/food-sensitivity-tracker.git
    ```
    2. Open the project in Xcode:
    ```
    cd food-sensitivity-tracker
    open FoodSensitivityTracker.xcodeproj
    ```

    3. Run the project on the simulator or your iOS device.}



[Software Demo Video](https://youtu.be/OEz7xT2lSaM)

# Development Environment
- **Language**: Swift, HTML, and CSS
- **Platform**: iOS
- **API**: FatSecret Platform API for food data
- **Database**: Firebase

{This project was built using mainly Swift for the functionality. Some displays were implemented using HTML and CSS. }

# Collaborators

{Kaylee Wright, Vilate Knapp, Cassidy Whitehead, and Sofia Beebe}

#Useful Websites
* [W3Schools.com](https://www.w3schools.com/html/default.asp)
* [Webkit.org](https://webkit.org)
* [Swift.org](https://www.swift.org)
* [Apple.com](https://developer.apple.com/xcode/)
* [Waldo.com](https://www.waldo.com/blog/swift-struct)
* [Auth0.com](https://auth0.com/blog/get-started-ios-authentication-swift-uikit/)



# Future Improvements
* Enhanced correlation algorithm for more accurate insights.
* Visualization tools for food and symptom patterns.
* Push notifications for reminding users to log symptoms.
* **Barcode Scanning**: We are experimenting with implementing barcode scanning to allow users to quickly add foods by scanning product bar-codes.
* **Period Tracker**: Adding features to correlate more health indications, like period cycles, could be very beneficial for the user. It become a more useful tool for all around health and wellness.

# License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
