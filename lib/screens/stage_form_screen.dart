import 'package:crcrme_stage_form_demo/misc/job_data_file_service.dart';
import 'package:flutter/material.dart';

class StageFormScreen extends StatefulWidget {
  const StageFormScreen({super.key});

  @override
  State<StageFormScreen> createState() => _StageFormScreenState();
}

class _StageFormScreenState extends State<StageFormScreen> {
  @override
  Widget build(BuildContext context) {
    final questions = JobDataFileService.sectors.first.jobs.first.questions;

    return Scaffold(
      appBar: AppBar(
        title: const Text("CR-CRME Formulaire de stage"),
      ),
      body: Form(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Visibility(
                visible: questions.contains("1"),
                child: Text("yey"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
