import 'package:cyberlife/constants/routes.dart';
import 'package:cyberlife/enums/joint_motor_function/joints.dart';
import 'package:cyberlife/models/angle_list.dart';
import 'package:cyberlife/models/app_state.dart';
import 'package:cyberlife/models/finger_escape_user_state.dart';
import 'package:cyberlife/models/grip_release_user_state.dart';
import 'package:cyberlife/models/joint_motor_function_user_state.dart';
import 'package:cyberlife/services/auth/auth_service.dart';
import 'package:cyberlife/views/auth/login_view.dart';
import 'package:cyberlife/views/auth/register_view.dart';
import 'package:cyberlife/views/auth/verify_email_view.dart';
import 'package:cyberlife/views/joint-motor-function/joint_motor_function_main.dart';
import 'package:cyberlife/views/home/new_result_view.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'theme.dart';
import 'package:cyberlife/views/home/home_view.dart';
import 'dart:developer' as devtools show log;

Future<void> initializeHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(AppStateNotifierAdapter());
  Hive.registerAdapter(JointMotorFunctionUserStateAdapter());
  Hive.registerAdapter(GripReleaseUserStateAdapter());
  Hive.registerAdapter(FingerEscapeUserStateAdapter());
  Hive.registerAdapter(AngleListAdapter());
  Hive.registerAdapter(JointsAdapter());
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeHive();

  Box<AppStateNotifier> storage = await Hive.openBox('storage');
  AppStateNotifier appStateNotifier = storage.get('userState', defaultValue: AppStateNotifier.defaultAppStateNotifier())!;

  runApp(ChangeNotifierProvider(
      create: (context) => appStateNotifier,
      builder: (context, provider) {
        return MaterialApp(
          title: 'Cyberlife',
          theme: AppTheme.lightTheme,
          home: const HomePage(),
          routes: {
            loginRoute: (context) => const LoginView(),
            registerRoute: (context) => const RegisterView(),
            homeRoute: (context) => const HomeView(),
            verifyEmailRoute: (context) => const VerifyEmailView(),
            jointMotorFunctionMainRoute: (context) =>
                const JointMotorFunctionMain(),
            newResultRoute: (context) => const NewResultView(),
          },
        );
      }));

  storage.close();
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
