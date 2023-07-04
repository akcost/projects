# Flutter Shopping List App

This is a simple shopping list app built using Flutter. It serves as a demonstration of various technologies and concepts, including Riverpod for state management, Firebase Realtime Database for backend storage, and error handling for a smooth user experience.

## Features

- Add and remove items on your shopping list.
- Realtime synchronization across devices using Firebase Realtime Database.
- Smooth and responsive user interface powered by Flutter.
- Error handling to handle network issues and provide user-friendly error messages.

## Technologies Used

- Flutter: A powerful framework for building cross-platform mobile applications.
- Riverpod: A state management solution for Flutter, providing a simple and intuitive way to manage app state.
- Firebase Realtime Database: A NoSQL database provided by Firebase, enabling seamless data synchronization in real time.

## Getting Started

To run the app on your local machine, follow these steps:

1. Clone the repository.
2. Set up Firebase Realtime Database.
3. Create a ```config.dart``` file in the ```lib``` folder and add the following line with your own database endpoint:  
   ```const String databaseUrl = 'YOUR_DATABASE_URL'; ```
4. Run the app using Flutter CLI or your preferred IDE.