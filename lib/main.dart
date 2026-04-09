import 'package:flutter/material.dart';
import 'theme_notifier.dart';
import 'login.dart'; // adjust import to match your login filename

void main() {
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
          title: 'Events Affairs',
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light(useMaterial3: false),
          darkTheme: ThemeData.dark(useMaterial3: false),
          themeMode: currentMode, // switches all screens at once
          home: const LoginPage(),
        );
      },
    );
  }
}
