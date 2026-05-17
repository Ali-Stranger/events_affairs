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

A selection of the current app screens showing core user flows and admin features.

| User Venue Screen | User Venue Screen | Push Notification |
|---|---|---|
| ![Venues in User Screen 1](https://github.com/user-attachments/assets/1a361608-ef3a-44a6-ae51-91cb26ca3fd0) | ![Venues in User Screen 2](https://github.com/user-attachments/assets/d85bc60f-2c76-4e51-9fc4-38cbb592d959) | ![Push Notification](https://github.com/user-attachments/assets/36b43ea6-9d55-4168-9a6c-39c93ba1b088) |

| Dark Mode | Urdu Language | Vendor Dashboard |
|---|---|---|
| ![Dark Mode](https://github.com/user-attachments/assets/259d4ebe-ab33-48d8-9214-562e8f82f0bb) | ![Urdu Language](https://github.com/user-attachments/assets/6483ea06-5d38-4c3c-8849-b1c0622de4ea) | ![Vendor Dashboard](https://github.com/user-attachments/assets/aad4449e-a248-4a67-aaac-bd072abf567b) |

| Vendor Inquiry Analytics | Reviews & Replies | Admin Leads |
|---|---|---|
| ![Easy Analysis of inquiries for vendor](https://github.com/user-attachments/assets/ee854ab7-a8eb-4104-b831-2a9a1339aa6b) | ![Reviews and Reply](https://github.com/user-attachments/assets/bfd5d0d5-e06a-426c-aaaf-e2dda14f9611) | ![Leads Section For Admin](https://github.com/user-attachments/assets/b704bcfe-2844-4d9d-89fe-dc09a41d17aa) |

| Vendor Profiles & Status | Admin Blog Management | User List |
|---|---|---|
| ![All Vendor Profile and their Status](https://github.com/user-attachments/assets/bf0d9457-2082-4437-a826-7164edd4e263) | ![Modification and Creation of Blogs at Admin Site](https://github.com/user-attachments/assets/ece5c603-af58-4325-b374-84f705dacaec) | ![List Of All Users](https://github.com/user-attachments/assets/85403a7f-de21-4daf-b36d-3754fb524f06) |

> If you want, you can replace these inline image URLs with local screenshot files or GitHub relative image paths after uploading them to the repository.

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


