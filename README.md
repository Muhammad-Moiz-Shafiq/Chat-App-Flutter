# Flash Chat

A chatting application made using Dart

## Setup Instructions

1. Clone the repository
2. Set up Firebase configuration:
    - Rename `lib/firebase_options_template.dart` to `lib/firebase_options.dart`
    - Fill in your Firebase configuration values
    - Place `google-services.json` in `android/app/`
    - Place `GoogleService-Info.plist` in `ios/Runner/`

3. Set up Cloud Functions (optional):
    - Create a service account key in Firebase Console
    - Create `functions/service-account.json`
    - Fill in your service account details

4. Install dependencies:
   ```bash
   flutter pub get
   cd functions && npm install
   ```

5. Run the app:
   ```bash
   flutter run
   ```

## Environment Files
The following files contain sensitive information and are not included in the repository:
- `lib/firebase_options.dart`
- `android/app/google-services.json`
- `ios/Runner/GoogleService-Info.plist`

Please obtain these files from your Firebase Console and add them to your local project.


## SneakPeek

![Screenshot 2025-02-25 194753](https://github.com/user-attachments/assets/3f259fd1-6be8-4631-88ac-5f4018543108)


## Dark Mode: 

![Screenshot 2025-02-25 195127](https://github.com/user-attachments/assets/9689339e-3684-4234-b091-8b73dfd1d126)

