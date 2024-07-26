# MatchMate - Matrimonial Card Interface (iOS)

## Project Description

MatchMate is an iOS app that simulates a matrimonial app by displaying match cards similar to Shaadi.com's card format. The app leverages SwiftUI for card design and integrates with an API to fetch user data. Users can interact with match cards to accept or decline matches, and the app will persist these decisions even when offline.

## Screenshots
![Simulator Screenshot - iPhone 15 Pro - 2024-07-26 at 10 33 16](https://github.com/user-attachments/assets/b7067261-9674-4e4a-9374-59037f4de57a)
![Simulator Screenshot - iPhone 15 Pro - 2024-07-26 at 10 33 22](https://github.com/user-attachments/assets/5abcf07f-e091-441a-ad79-ac96521a91e6)

## Requirements

- iOS 13.0+
- Xcode 12.0+
- Swift 5.0+

## Installation

1. Clone the repository:

2. Open the project in Xcode.

3. Build and run the app on a simulator or physical device.



## Usage

1. Upon launching the app, the main screen displays a list of profiles  API.

2. Scroll through the list to browse different profiles.

3. Tap on an for accept and decline match.

4. Tap on tab to switch matchlist.

5. Enjoy exploring the profiles for match.

## Architecture

The MatchMate app follows the MVVM (Model-View-ViewModel) architecture pattern to separate concerns and improve testability and maintainability. The key components of the architecture include:

- **Model**: Represents the data entities used in the app, such as Apod (Astronomy Picture of the Day).
- **View**: Represents the user interface elements, including ViewControllers and custom views.
- **ViewModel**: Acts as an intermediary between the View and Model layers, providing data and business logic to the View.

## Dependencies

- [SDWebImage](https://github.com/SDWebImage/SDWebImage): For asynchronous loading and caching of images.
- [SwiftUI](https://developer.apple.com/documentation/swiftui): For building user interface components.
- [Core Data](https://developer.apple.com/documentation/coredata): For a similar local database to store user profiles and their acceptance/decline status.
  



## Author

[Amrut Waghmare]

