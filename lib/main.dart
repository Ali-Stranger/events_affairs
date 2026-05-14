import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'theme_notifier.dart';
import 'login.dart';
import 'app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder2<ThemeMode, Locale>(
      firstListenable: themeNotifier,
      secondListenable: localeNotifier,
      builder: (context, currentMode, currentLocale, _) {
        return MaterialApp(
          title: 'Events Af@airs',
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light(useMaterial3: false),
          darkTheme: ThemeData.dark(useMaterial3: false),
          themeMode: currentMode,
          locale: currentLocale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: const LoginPage(),
        );
      },
    );
  }
}

class ValueListenableBuilder2<A, B> extends StatelessWidget {
  const ValueListenableBuilder2({
    super.key,
    required this.firstListenable,
    required this.secondListenable,
    required this.builder,
  });

  final ValueListenable<A> firstListenable;
  final ValueListenable<B> secondListenable;
  final Widget Function(BuildContext, A, B, Widget?) builder;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<A>(
      valueListenable: firstListenable,
      builder: (context, firstValue, child) {
        return ValueListenableBuilder<B>(
          valueListenable: secondListenable,
          builder: (context, secondValue, child) {
            return builder(context, firstValue, secondValue, child);
          },
        );
      },
    );
  }
}
