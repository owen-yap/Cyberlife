import 'package:flutter/material.dart';

class AppTheme {
  static const Color lightGreen = Color(0xFF00DCA6);
  static const Color navy = Color(0xFF07203C);
  static const Color lightRed = Color.fromARGB(255, 238, 147, 146);

  static Color green = Colors.green.shade700;
  static Color red = Colors.red.shade600;

  static const displayLarge = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: navy,
  );

  static const displayMedium = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: navy,
  );

  static const displaySmall = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: navy,
  );

  static var bodyLarge = TextStyle(fontSize: 20, color: Colors.grey.shade800);

  static var bodyMedium = TextStyle(fontSize: 18, color: Colors.grey.shade800);

  static final ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.blue,
    fontFamily: 'Roboto',
    textTheme: TextTheme(
        displaySmall: displaySmall,
        displayMedium: displayMedium,
        displayLarge: displayLarge,
        bodyMedium: bodyMedium,
        bodyLarge: bodyLarge),
    buttonTheme: ButtonThemeData(
      buttonColor: lightGreen,
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(vertical: 30.0, horizontal: 48.0),
        ),
        backgroundColor: MaterialStateProperty.all(lightGreen),
        foregroundColor: MaterialStateProperty.all(navy),
        textStyle: MaterialStateProperty.all(displaySmall),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(64.0),
          ),
        ),
        // Add other desired button style modifications
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: lightGreen, // Set the background color of the app bar
      foregroundColor: navy, // Set the text color of the app bar
      elevation: 2.0, // Set the elevation of the app bar
      // Add other desired app bar style modifications
    ),
  );
}
