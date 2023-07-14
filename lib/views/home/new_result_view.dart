import 'package:cyberlife/services/auth/auth_service.dart';
import 'package:cyberlife/services/cloud/firebase_cloud_storage.dart';
import 'package:flutter/material.dart';

class NewResultView extends StatefulWidget {
  const NewResultView({super.key});

  @override
  State<NewResultView> createState() => _NewResultViewState();
}

class _NewResultViewState extends State<NewResultView> {
  late final FirebaseCloudStorage _resultsService;

  @override
  void initState() {
    _resultsService = FirebaseCloudStorage();
    super.initState();
  }

  Future<void> createNewResult() async {
    final currentUser = AuthService.firebase().currentUser!;
    final userId = currentUser.id;

    await _resultsService
        .createNewResult(ownerUserId: userId)
        .then((newResult) async {
      await _resultsService.updateResult(
          documentId: newResult.documentId, text: 'Success');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Result')),
      body: FutureBuilder(
        future: createNewResult(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return const Text(
                  'Creating new result and uploading onto firebase');
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
