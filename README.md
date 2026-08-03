# Final Year Project

A Flutter mobile application with Firebase integration to teach children about social engineering 
(phishing, baiting and pretexting)

## Tech Stack 
- Flutter 
- Dart 
- Firebase (Auth, Firestore)
- Lottie
- Figma 

------------------------------------------------------
## Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (>=3.11.4)
- [Dart SDK](https://dart.dev/get-dart) (included with Flutter)
- [Android Studio](https://developer.android.com/studio) or [Xcode](https://developer.apple.com/xcode/) (for iOS)
- A connected device or emulator 

------------------------------------------------------
## Getting Started

### 1. Clone the repository

```bash
git clone <repository-url>
cd final-year-project
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Run the app

```bash
flutter run
```

To target a specific device:

```bash
flutter devices # list available devices
flutter run -d <device-id> # run on a specific device
```
------------------------------------------------------
## File Structure

| Path | Description |
|------|-------------|
| `assets/` | animations (Lottie JSON) and sound effects |
| `lib/screens/` | all lesson screens (password, phishing, baiting) |
| `lib/services/` | firebase, user data, and sound services |
| `lib/widgets/` | shared widgets (cat mascot, nav bar, XP award) |
| `lib/firebase_options.dart` | firebase configuration |
| `lib/main.dart` | app main entry point |
------------------------------------------------------
## Common Commands

| Command | Description |
|---|---|
| `flutter run` | Run in debug mode |
| `flutter run --release` | Run in release mode |
| `flutter test` | Run tests |
| `flutter clean` | Clear build cache |
| `flutter pub get` | Install dependencies |

