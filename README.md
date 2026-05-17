# Events Affairs

**Events Affairs** is a Flutter-based event management application for planning and managing event bookings, vendors, venues, and couple profiles with Firebase-backed authentication and real-time data storage.

## App Description

Events Affairs helps users discover vendors and venues, manage bookings, save favorites, contact organizers, and track event details in a simple mobile-first interface.

## Features

- [x] User authentication with Firebase Auth
- [x] Vendor and venue discovery screens
- [x] Booking management and saved items
- [x] Couple profile editing and event planning tools
- [x] Push notifications support via local notifications
- [x] In Urdu Language using AppLocalizatiom
- [x] Image upload support for event and profile assets
- [x] Firebase Firestore, Realtime Database, and Storage integration

## Installation Instructions

1. Install Flutter: https://flutter.dev/docs/get-started/install
2. Install Android Studio or Xcode for your target platform.
3. Open the project folder in VS Code or Android Studio.
4. Run `flutter pub get` to install dependencies.
5. Configure Firebase before running the app.

## How to Run the Project

From the project root, run:

```bash
flutter pub get
flutter run
```

If you need to target a specific device:

```bash
flutter run -d <device_id>
```

For Android build:

```bash
flutter build apk
```

For iOS build:

```bash
flutter build ios
```

## Dependencies and Packages Used

- `flutter`
- `flutter_localizations`
- `webview_flutter`
- `url_launcher`
- `google_maps_flutter`
- `image_picker`
- `cupertino_icons`
- `flutter_local_notifications`
- `firebase_core`
- `firebase_auth`
- `cloud_firestore`
- `firebase_storage`
- `firebase_database`
- `shared_preferences`
- `flutter_test` (dev)
- `flutter_lints` (dev)

## Screenshots

Venues in User Screen
<img width="446" height="972" alt="Screenshot 2026-05-17 164835" src="https://github.com/user-attachments/assets/1a361608-ef3a-44a6-ae51-91cb26ca3fd0" />
<img width="461" height="923" alt="Screenshot 2026-05-17 164912" src="https://github.com/user-attachments/assets/d85bc60f-2c76-4e51-9fc4-38cbb592d959" />
Push Notification
<img width="452" height="912" alt="Screenshot 2026-05-17 165016" src="https://github.com/user-attachments/assets/36b43ea6-9d55-4168-9a6c-39c93ba1b088" />
Dark Mode
<img width="483" height="860" alt="App Dark Mode" src="https://github.com/user-attachments/assets/259d4ebe-ab33-48d8-9214-562e8f82f0bb" />
Urdu Language
<img width="458" height="906" alt="Urdu Language" src="https://github.com/user-attachments/assets/6483ea06-5d38-4c3c-8849-b1c0622de4ea" />
Vendor DashBoard
<img width="458" height="867" alt="Vendor Dashboard" src="https://github.com/user-attachments/assets/aad4449e-a248-4a67-aaac-bd072abf567b" />
Easy Analysis of inquiries For vendor
<img width="451" height="826" alt="Easy Analysis of inquiries for vendor" src="https://github.com/user-attachments/assets/ee854ab7-a8eb-4104-b831-2a9a1339aa6b" />
Reviews and Reply
<img width="460" height="865" alt="Reviews and Reply " src="https://github.com/user-attachments/assets/bfd5d0d5-e06a-426c-aaaf-e2dda14f9611" />
Leads Section For Admin
<img width="462" height="796" alt="Leads Section For admin" src="https://github.com/user-attachments/assets/b704bcfe-2844-4d9d-89fe-dc09a41d17aa" />
All Vendor Profile and their Status
<img width="447" height="802" alt="All vendors Profile and their Status" src="https://github.com/user-attachments/assets/bf0d9457-2082-4437-a826-7164edd4e263" />
Modification and Creation of Blogs at Admin Site
<img width="448" height="572" alt="To Modifiy and Create Blogs" src="https://github.com/user-attachments/assets/ece5c603-af58-4325-b374-84f705dacaec" />
List of All users 
<img width="458" height="721" alt="List Of All Users" src="https://github.com/user-attachments/assets/85403a7f-de21-4daf-b36d-3754fb524f06" />






## Firebase Setup Instructions

1. Create a Firebase project at https://console.firebase.google.com/
2. Add Android and/or iOS apps to the Firebase project.
3. Download `google-services.json` for Android and place it in `android/app/`.
4. Download `GoogleService-Info.plist` for iOS and place it in `ios/Runner/`.
5. Enable Firebase Authentication in the Firebase console.
6. Enable Firestore, Realtime Database, and Storage as required.
7. Install Firebase CLI if needed and ensure `firebase_options.dart` is generated or configured.
8. Update `android/app/build.gradle` and `ios/Runner/` settings if needed for Firebase SDK support.

## Known Issues / Limitations

- Some UI screens may need refinement for different device sizes.
- Firebase rules and security are not included in this repository.
- Offline support is limited to what Firebase provides by default.
- Screenshot assets are not embedded in the repository yet.

## Future Enhancements

- Add full admin analytics dashboard and reporting.
- Improve vendor search and filtering.
- Add in-app chat between users and vendors.
- Implement event reminders and calendar sync.
- Add multi-language localization support.

## Credits and References

- Built with Flutter and Firebase
- Design inspiration from event planning / wedding planning apps
- Figma design source: https://www.figma.com/design/5q2w3w5qHIUfCqGQCznvsl/Events-Affairs?node-id=0-1&p=f&t=zL5QCEeTysW03BOV-0
- Firebase documentation: https://firebase.google.com/docs
- Flutter documentation: https://flutter.dev/docs


