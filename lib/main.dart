import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cyberlife/utils/firebase_options.dart';
import 'package:cyberlife/screens/home.dart';
import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cyberlife',
      theme: AppTheme.lightTheme,
      home: const Home(),
    );
  }
}
