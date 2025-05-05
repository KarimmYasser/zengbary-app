import 'package:flutter/material.dart';

import 'home_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zengbary',
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            fontFamily: 'Urbanist', // Use your custom font
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontFamily: 'Urbanist'),
          bodyMedium: TextStyle(fontFamily: 'Urbanist'),
          bodySmall: TextStyle(fontFamily: 'Urbanist'),
          displayLarge: TextStyle(fontFamily: 'Urbanist'),
          displayMedium: TextStyle(fontFamily: 'Urbanist'),
          displaySmall: TextStyle(fontFamily: 'Urbanist'),
          headlineLarge: TextStyle(fontFamily: 'Urbanist'),
          headlineMedium: TextStyle(fontFamily: 'Urbanist'),
          headlineSmall: TextStyle(fontFamily: 'Urbanist'),
          titleLarge: TextStyle(fontFamily: 'Urbanist'),
          titleMedium: TextStyle(fontFamily: 'Urbanist'),
          titleSmall: TextStyle(fontFamily: 'Urbanist'),
          labelLarge: TextStyle(fontFamily: 'Urbanist'),
          labelMedium: TextStyle(fontFamily: 'Urbanist'),
          labelSmall: TextStyle(fontFamily: 'Urbanist'),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
