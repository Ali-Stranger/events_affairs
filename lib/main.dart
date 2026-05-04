import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'theme_notifier.dart';
import 'login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentMode, _) {
        return MaterialApp(
          title: 'Events Af@airs',
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light(useMaterial3: false),
          darkTheme: ThemeData.dark(useMaterial3: false),
          themeMode: currentMode,
          home: const LoginPage(),
        );
      },
    );
  }
}
