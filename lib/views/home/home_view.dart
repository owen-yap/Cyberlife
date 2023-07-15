// ignore_for_file: file_names

import 'package:cyberlife/constants/routes.dart';
import 'package:cyberlife/enums/menu_action.dart';
import 'package:cyberlife/services/auth/auth_service.dart';
import 'package:cyberlife/services/cloud/firebase_cloud_storage.dart';
import 'package:cyberlife/views/joint-motor-function/joint_motor_function_instruct.dart';
import 'package:cyberlife/views/open_close.dart';
import 'package:cyberlife/views/pain_map.dart';
import 'package:cyberlife/views/pinky_supination.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final FirebaseCloudStorage _resultsService;
  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _resultsService = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Results'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(newResultRoute);
            },
            icon: const Icon(Icons.add),
          ),
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              devtools.log(value.toString());
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout) {
                    AuthService.firebase().logOut();
                    if (context.mounted) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        loginRoute,
                        (_) => false,
                      );
                    }
                  }
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                    value: MenuAction.logout, child: Text('logout')),
              ];
            },
          )
        ],
      ),
      body: FutureBuilder(
          future: _resultsService.getResults(ownerUserId: userId),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const CircularProgressIndicator();
              case ConnectionState.done:
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      child: const Text("Pain Map"),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    PainMap(key: UniqueKey())));
                      },
                    ),
                    ElevatedButton(
                      child: const Text("Joint Motor Function"),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const JointMotorFunctionInstructions()));
                      },
                    ),
                    ElevatedButton(
                      child: const Text("Open-Close Test"),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const OpenClose()));
                      },
                    ),
                    ElevatedButton(
                      child: const Text("Pinky Supination Test"),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const PinkySupination()));
                      },
                    ),
                  ],
                );
              default:
                return const CircularProgressIndicator();
            }
          }),
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
          title: const Text('Sign Out'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Log Out'),
            ),
          ]);
    },
  ).then((value) => value ?? false);
}
