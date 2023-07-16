import 'package:cyberlife/components/auth/auth_button.dart';
import 'package:cyberlife/components/auth/auth_textfield.dart';
import 'package:flutter/material.dart';

import 'package:cyberlife/constants/routes.dart';
import 'package:cyberlife/services/auth/auth_exceptions.dart';
import 'package:cyberlife/services/auth/auth_service.dart';
import 'package:cyberlife/utils/show_error_dialog.dart';

import 'dart:developer' as devtools show log;

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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

  void register() async {
    final email = _email.text;
    final password = _password.text;

    try {
      await AuthService.firebase().createUser(
        email: email,
        password: password,
      );
      await AuthService.firebase().sendEmailVerification();
      if (context.mounted) {
        Navigator.of(context).pushNamed(verifyEmailRoute);
      }
    } on WeakPasswordAuthException {
      await showErrorDialog(
        context,
        'Weak password',
      );
    } on EmailAlreadyInUseAuthException {
      devtools.log('Email already in use');
      await showErrorDialog(
        context,
        'This email address is already in use',
      );
    } on GenericAuthException {
      await showErrorDialog(
        context,
        'Registration error',
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
            "Register an account",
            style: TextStyle(
                color: Colors.black, fontSize: 32, fontWeight: FontWeight.bold),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(loginRoute, (route) => false);
            },
            child: const Text('Already a user? Login here'),
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
          Expanded(
              child: Container(
            color: Colors.grey.shade100,
          )),
          AuthButton(
            onPressed: register,
            text: 'Register',
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
