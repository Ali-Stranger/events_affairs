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

Add your app screenshots here after uploading them.

- `screenshot1.png`
- `screenshot2.png`
- `screenshot3.png`
- `screenshot4.png`
- `screenshot5.png`

> Replace the above placeholders with actual screenshot image links or markdown once images are available.

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


