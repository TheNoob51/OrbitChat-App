# 🚀 OrbitChat - Interactive Space Learning App

<p align="center">  
  <img  width="250px" src="https://github.com/TheNoob51/OrbitChat-App/blob/main/assets/images/logo/logo2.png">
</p>

**OrbitChat** is an educational app developed during the NASA Hackathon with the aim of making space exploration both fun and educational. OrbitChat allows users, especially kids, to interact with space-themed features like real-time information about planets, space news, Mars temperature, NASA's "Photo of the Day," and a NASA Gallery for beautiful imagery. The app also includes an AI-powered chatbot for educational conversations about space.

## 🎯 Main Purpose

The project was developed as part of a hackathon where the problem statement required us to create an educational app that combines entertainment and learning about space. OrbitChat aims to inspire curiosity and a love for space by offering interactive and engaging features.

## 🌟 Features

- **AI-powered Chatbot:** Interact with a chatbot to learn space facts in a conversational and fun manner. Chat history is saved using Firestore for personalized experiences.
- **NASA Photo of the Day:** Get the latest "Photo of the Day" directly from NASA and explore the wonders of space.
- **Planet Information:** Learn interesting facts and details about the planets in our solar system.
- **Space News:** Stay updated with the latest space-related news from reliable sources.
- **Mars Temperature:** View real-time temperature updates on Mars.
- **NASA Gallery:** Explore an extensive collection of NASA’s space imagery.
- **User Authentication:** Ensures personalized sessions for each user using Firebase Authentication.
  
## 🚀 Technology Stack

- **Frontend:** Flutter (Dart)
- **Backend:** Firestore (for data storage, including chat logs)
- **Authentication:** Firebase Authentication
- **API Integrations:** NASA APIs, Spaceflight News API
- **Database:** Google Firebase Firestore (for user data, chat history, etc.)

## 🛠️ Getting Started

### Prerequisites

Make sure you have the following installed on your local machine:

- Flutter SDK
- Dart
- Firebase account (for Firestore and Firebase Authentication)

### Installation

1. **Clone the repository:**

   ```bash
   git clone https://github.com/your-username/orbitchat.git
   cd orbitchat
   ```

2. **Install dependencies:**

   ```bash
   flutter pub get
   ```

3. **Set up Firebase:**

   - Create a Firebase project at [Firebase Console](https://console.firebase.google.com/).
   - Enable **Firebase Authentication** and **Firestore**.
   - Download the `google-services.json` file for Android or `GoogleService-Info.plist` for iOS.
   - Place these files in the respective directories (`android/app` for Android and `ios/Runner` for iOS).

4. **Run the project:**

   ```bash
   flutter run
   ```

---

## 📚 API Setup

To fetch the space-related data, you will need the following APIs:

- **NASA APIs**: Obtain an API key from the [NASA API portal](https://api.nasa.gov/).
- **Spaceflight News API**: No key is required. The Space News feature pulls data directly from this API.

Update the API keys and URLs in the app’s environment configuration.

---

## 📂 Project Structure

```
/lib
  /models        # Data models
  /screens       # UI screens
  /services      # API and Firebase services
  /widgets       # Custom reusable widgets
  main.dart      # App entry point
```

---

## 🙌 Contribution

We welcome contributions! If you'd like to contribute, please follow these steps:

1. **Fork the repository.**
2. **Create a new branch** for your feature (`git checkout -b feature/feature-name`).
3. **Commit your changes** (`git commit -m 'Add some feature'`).
4. **Push to the branch** (`git push origin feature/feature-name`).
5. **Open a pull request**.

---

## 💡 Future Improvements

- Implement real-time chat with other users.
- Add push notifications for NASA events or space news updates.
- Include additional space exploration missions.

---

## 🏆 Hackathon Credits

This project was developed as part of the **NASA Hackathon** by **Team Blacksheeps**:

- **Ankur Raj**
- **Harsh Raj**
- **Gyan Vardhan**

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🤝 Acknowledgements

- NASA API for space imagery and data
- Spaceflight News API for real-time news updates
- Firebase for backend services and authentication

Feel free to raise an issue if you encounter any problems or need further assistance!

---

This README provides detailed information about the app, setup instructions, and how others can contribute. Let me know if you'd like any other adjustments!
