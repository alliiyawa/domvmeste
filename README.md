# dom_vmeste

# 🏢 DOM VMESTE — Residential Complex App

A mobile application for residents of a residential complex, built with Flutter and Firebase.

---

## 📱 About

**DOM VMESTE** (Home Together) is an app that brings residents of an apartment complex together in one place. Residents can read complex news, view neighbor announcements, and quickly contact the management company.

---

## ✨ Features

### 🔐 Authentication
- Sign in with Google account (Firebase Auth)
- Automatic session persistence
- Sign out

### 🏠 Home Screen
- Greeting with user name and profile photo
- Quick access buttons: Repair, Lost & Found, Contacts
- Preview of latest announcements
- Preview of latest news

### 📰 News
- Real-time list of complex news
- Add new post (title + description)
- Delete post with confirmation dialog
- Publication date for each post

### 📢 Announcements
- Real-time list of resident announcements
- Add new announcement
- Delete announcement with confirmation dialog

### 📞 Contacts
- Management company phone number
- Quick call button
- WhatsApp message button

---

## ⚙️ Requirements

| Tool | Version |
|---|---|
| Flutter | 3.41.1 (stable) |
| Dart | 3.11.0 |
| DevTools | 2.54.1 |
| Android Studio | Hedgehog or newer |
| Android SDK | min API 21 (Android 5.0) |

---

## 🛠 Tech Stack

| Package | Version | Description |
|---|---|---|
| flutter_bloc | 9.1.1 | State management |
| go_router | 17.1.0 | Navigation |
| firebase_core | 4.4.0 | Firebase core |
| firebase_auth | 6.1.4 | Authentication |
| cloud_firestore | 6.1.2 | Database |
| google_sign_in | 7.2.0 | Google sign-in |
| flutter_dotenv | 6.0.0 | Environment variables |
| intl | 0.20.2 | Localization & dates |
| equatable | 2.0.8 | Object comparison |
| flutter_svg | 2.2.3 | SVG icons |

---

## 🏗 Architecture

The project follows a **Feature-first** structure with the **BLoC** pattern:

```
lib/
├── core/                  # App core
│   ├── constants/         # Constants
│   ├── router/            # Navigation (GoRouter)
│   ├── services/          # Firebase services
│   ├── theme/             # App theme
│   └── utils/             # Utilities (logger)
├── data/
│   ├── models/            # Data models
│   │   ├── user_model.dart
│   │   ├── news_model.dart
│   │   └── announcement_model.dart
│   └── repositories/      # Repositories
├── features/              # Feature modules
│   ├── app/               # Root widget + AppBloc
│   ├── login/             # Login screen
│   ├── home/              # Home screen + navigation
│   ├── news/              # News + NewsBloc
│   ├── announcements/     # Announcements + AnnouncementsBloc
│   └── contacts/          # Contacts screen
└── widgets/               # Reusable widgets
```

---

## 🚀 Getting Started

### Prerequisites
- Flutter 3.41.1 (stable)
- Dart 3.11.0
- Android Studio Hedgehog or newer
- Firebase project with the following services enabled:
  - Authentication (Google Sign-In)
  - Cloud Firestore

### Installation

1. Clone the repository:
```bash
git clone https://github.com/your-repo/dom_vmeste.git
cd dom_vmeste
```

2. Install dependencies:
```bash
flutter pub get
```

3. Create a `.env` file in the project root:
```
SERVER_CLIENT_ID=your_client_id.apps.googleusercontent.com
```

4. Add `google-services.json` to `android/app/`

5. Run the app:
```bash
flutter run
```

---

## 🗄 Firestore Database Structure

### Collection `news`
```
news/
└── {documentId}
    ├── title: String
    ├── description: String
    ├── imageUrl: String
    └── createdAt: Timestamp
```

### Collection `announcements`
```
announcements/
└── {documentId}
    ├── title: String
    ├── description: String
    ├── imageUrl: String
    └── createdAt: Timestamp
```

---

## 👩‍💻 Developer

Developed as a student project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
