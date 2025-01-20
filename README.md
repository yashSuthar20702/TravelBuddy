# Travel Buddy iOS Application

Travel Buddy is an iOS application designed to assist users in planning trips, tracking locations, and managing expenses. The app is developed using **Swift** and incorporates features such as **Core Data** for saving trip-related information, **GPS integration** via MapKit, and real-time weather updates using external APIs. Travel Buddy provides a simple, user-friendly, and visually appealing experience, supporting both light and dark modes for better usability.

---

## Features

### Home Page
- **Title & Navigation Bar:** Clear layout with intuitive navigation.
- **Add Trip Button:** Allows users to navigate to the Add Trip page effortlessly.

### Add Trip Page
- **Trip Form:** Users can input trip details such as name, destination, start date, and end date.
- **Save Trip:** Saves trip details with validation to ensure accuracy.
- **Responsive Layout:** Optimized for all screen sizes.

### Trip List Page
- **Trip Display:** Displays a list of saved trips with names and destinations.
- **Core Data Integration:** Fetches and presents saved trips efficiently.
- **Trip Details:** Tapping on a trip provides more comprehensive information.

### Trip Detail Page
- **Trip Info:** Shows trip details along with an integrated map.
- **Map Integration:** Displays destination using **MapKit**.
- **Weather Info:** Provides real-time weather updates using a weather API.

### Trip Expenses Page
- **Add Expenses:** Users can input expense details such as name and amount.
- **Expense List:** Displays all recorded expenses associated with a trip.
- **Total Calculation:** Automatically calculates the total expenditure.

### Extra Features
- **Search:** Enables users to filter trips by name.
- **Delete Trip:** Allows users to remove trips with confirmation.
- **Animations:** Smooth transitions and visual effects for a better user experience.

---

## Design

- **Primary Color:** Black
- **Accent Color:** Red
- Supports both **Light** and **Dark** mode for enhanced usability.

---

## Installation and Setup

Follow the steps below to install and run the Travel Buddy iOS application:

### Prerequisites

Ensure that you have the following installed on your system:
- **macOS (latest version recommended)**
- **Xcode 14.0 or later**
- **iOS Simulator (available within Xcode)**
- **Swift 5.0**

### Steps to Run the Application

1. **Download and Install Xcode:**
   - Visit the official Apple Developer website or Mac App Store to download Xcode.
   - Install it by following the on-screen instructions.

2. **Clone the Repository:**
   - Open the Terminal and run the following command:
     ```
     git clone https://github.com/yashThinkwik/TravelBuddy/
     ```

3. **Open the Project in Xcode:**
   - Navigate to the cloned folder and open `TravelBuddy.xcodeproj` in Xcode.

4. **Select a Simulator or Device:**
   - In Xcode, choose an iOS simulator (e.g., iPhone 14 Pro) or connect a physical device.

5. **Run the Application:**
   - Click on the `Run` button (▶) in Xcode to build and launch the app.

---

## How to Use

1. **Add a Trip:**
   - Fill out trip details such as name, destination, and dates, then save.

2. **View Trips:**
   - Browse all saved trips listed in the app.

3. **Trip Details:**
   - Tap on a trip to view comprehensive details and the map.

4. **Add Expenses:**
   - Enter expense details and track trip-related expenses.

5. **Search:**
   - Use the search feature to locate specific trips quickly.

6. **Delete:**
   - Remove unwanted trips from the list with confirmation.

---

## Technologies Used

- **Swift:** Used for app development.
- **Core Data:** Handles data persistence and storage.
- **MapKit:** Provides mapping and GPS tracking features.
- **Weather API:** Fetches current weather data for trip destinations.

---

## Requirements

- **iOS Version:** 14.0 or later
- **Xcode Version:** 14.0 or later
- **Swift Version:** 5.0

---

## Future Enhancements

Some planned improvements for the Travel Buddy app include:
- Integrating cloud-based storage for syncing trips across devices.
- Implementing push notifications for upcoming trip reminders.
- Adding currency conversion for international trips.
- Optimizing the app for better performance and scalability.

---

## Acknowledgements

This app was developed as part of the **Fall 2024 PROG8471-iOS course** at **Conestoga College**. Special thanks to instructors and classmates for their guidance and support.

---

## License

This project is intended for educational purposes only and is not for commercial use.

---

## Contact

For any inquiries or suggestions regarding the project, feel free to reach out via:
- **Email:** yashraj20702.ca@gmail.com

---

Thank you for using the Travel Buddy iOS application!
