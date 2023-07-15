import 'package:cyberlife/components/auth/auth_textfield.dart';
import 'package:flutter/material.dart';

import 'package:cyberlife/constants/routes.dart';
import 'package:cyberlife/services/auth/auth_exceptions.dart';
import 'package:cyberlife/services/auth/auth_service.dart';

import '../../utils/show_error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void logIn() async {
    final email = _email.text;
    final password = _password.text;
    try {
      await AuthService.firebase().logIn(
        email: email,
        password: password,
      );
      final user = AuthService.firebase().currentUser;
      if (context.mounted) {
        if (user?.isEmailVerified ?? false) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            homeRoute,
            (route) => false,
          );
        } else {
          Navigator.of(context).pushNamedAndRemoveUntil(
            verifyEmailRoute,
            (route) => false,
          );
        }
      }
    } on UserNotFoundAuthException {
      await showErrorDialog(
        context,
        'User not found',
      );
    } on WrongPasswordAuthException {
      await showErrorDialog(
        context,
        'Wrong credentials',
      );
    } on GenericAuthException {
      await showErrorDialog(
        context,
        'Authentication error',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Column(
        children: [
          const SizedBox(height: 100),
          const Text(
            "Welcome back",
            style: TextStyle(
                color: Colors.black, fontSize: 32, fontWeight: FontWeight.bold),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                registerRoute,
                (route) => false,
              );
            },
            child: const Text("Don't have an account? Register Here"),
          ),
          const SizedBox(height: 50),
          AuthTextField(
            controller: _email,
            hintText: 'Email',
            obscureText: false,
          ),
          const SizedBox(height: 10),
          AuthTextField(
            controller: _password,
            hintText: 'Password',
            obscureText: true,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      registerRoute,
                      (route) => false,
                    );
                  },
                  child: const Text("Forgot Password?"),
                ),
              ],
            ),
          ),
          Expanded(
              child: Container(
            color: Colors.grey.shade100,
          )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: ElevatedButton(
              onPressed: logIn,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text('Login'),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
