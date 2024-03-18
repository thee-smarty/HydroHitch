# Jal Jeevan

Welcome to the Jal Jeevan Flutter project repository! This Android application aims to address water-related issues locally by allowing users to raise problems through an intuitive interface. The prolems will be submitted to the local authorities to take a look and solve them. The app utilizes Flutter for the front-end, Firebase for the database, and OpenStreetMap for mapping functionalities.

## Features

### Main Screen

The main screen of the application comprises a map showcasing the user's current location and a sliding-up panel for easy access to key features.

- **Map**: Displays the map with the user's current location.
- **Sliding-up Panel**: Contains buttons for raising a problem, accessing app information, viewing problems, and checking user details.

### Raise a Problem

By clicking the "Raise a Problem" button, users are directed to a form screen to provide details about the water-related issue.

- **Form Fields**: Name, Number, Problem Type, Description, Severity, Location, and Image upload.
- **Submit Button**: Adds the entered data to the Firebase database.

### App Information

This section provides information about the application, including its purpose and features.

### User Information

Displays basic details about the user, including authentication credentials and a list of problems they have raised.

### Problems Screen

Navigating to this screen presents a list of all problems raised through the app.

- **Locate on Map Button**: Takes the user to the map screen with markers indicating the locations of the raised problems.

### Map Screen

Utilizes OpenStreetMap to display the locations of water-related problems. Clicking on a problem provides detailed information.

## Technology Stack

- **Framework**: Flutter
- **Database**: Firebase
- **Mapping**: OpenStreetMap
- **IDE**: Android Studio

## Getting Started

To run the Jal Jeevan app locally, follow these steps:

1. Clone the repository.
2. Open the project in Android Studio.
3. Ensure Flutter and Dart plugins are installed.
4. Set up a Firebase project and link it to the app.
5. Run the app on an emulator or physical device.

or you can directly download the application in the playstore : [Jal Jeevan](https://play.google.com/store/apps/details?id=com.theesmarty.epics)

Feel free to explore and contribute to the project. If you encounter any issues or have suggestions, please open an issue or create a pull request.

Enjoy Developing!
