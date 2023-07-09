import 'package:cyberlife/constants/routes.dart';
import 'package:cyberlife/services/auth/auth_service.dart';
import 'package:cyberlife/views/auth/login_view.dart';
import 'package:cyberlife/views/auth/register_view.dart';
import 'package:cyberlife/views/auth/verify_email_view.dart';
import 'package:flutter/material.dart';
import 'package:cyberlife/views/home.dart';
import 'dart:developer' as devtools show log;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    title: 'Cyberlife Prototype',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
    ),
    home: const HomePage(),
    routes: {
      loginRoute: (context) => const LoginView(),
      registerRoute: (context) => const RegisterView(),
      homeRoute: (context) => const HomeView(),
      verifyEmailRoute: (context) => const VerifyEmailView(),
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: FutureBuilder(
          future: AuthService.firebase().initialize(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                final user = AuthService.firebase().currentUser;
                if (user != null) {
                  devtools.log(user.toString());
                  if (user.isEmailVerified) {
                    return const HomeView();
                  } else {
                    return const VerifyEmailView();
                  }
                } else {
                  return const LoginView();
                }

              default:
                return const CircularProgressIndicator();
            }
          },
        ));
  }
}
