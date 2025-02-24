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

![IMG-20250224-WA0003](https://github.com/user-attachments/assets/d9de022f-fc45-4542-bcc2-98a0798bf1cf)

![IMG-20250224-WA0005](https://github.com/user-attachments/assets/4a9230cd-c11a-42ed-b3f7-12a842910123)

![IMG-20250224-WA0001](https://github.com/user-attachments/assets/40bda7eb-2064-4d68-923e-968adfba44a0)

![IMG-20250224-WA0006](https://github.com/user-attachments/assets/9373d051-6d2c-4f2e-9931-fca4f737171b)

Dark Mode: 

![IMG-20250224-WA0002](https://github.com/user-attachments/assets/b2e1b955-6e67-4026-9a4d-b2b9761496c3)
