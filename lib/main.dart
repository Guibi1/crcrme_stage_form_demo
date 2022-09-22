import 'package:flutter/material.dart';

import '/misc/job_data_file_service.dart';
import '/misc/question_file_service.dart';
import '/screens/stage_form_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await JobDataFileService.loadData();
  await QuestionFileService.loadData();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "CR-CRME Formulaire de stage",
      home: StageFormScreen(),
    );
  }
}
