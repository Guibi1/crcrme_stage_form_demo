import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '/common/widgets/autocomplete_field.dart';
import '/common/widgets/question_with_checkbox_list.dart';
import '/common/widgets/question_with_radio_bool.dart';
import '/common/widgets/question_with_text.dart';
import '/misc/form_service.dart';
import '/misc/job_data_file_service.dart';
import '/misc/question_file_service.dart';

class StageFormScreen extends StatefulWidget {
  const StageFormScreen({super.key});

  @override
  State<StageFormScreen> createState() => _StageFormScreenState();
}

class _StageFormScreenState extends State<StageFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _sectorController = TextEditingController();
  final _specializationController = TextEditingController();

  String? errorSector;
  String? errorSpecialization;

  ActivitySector? sector;
  Specialization? specialization;
  Set<String> questions = {};

  void _submit() {
    if (sector == null || specialization == null) return;
    if (!FormService.validateForm(_formKey)) return;

    _formKey.currentState!.save();
    _formKey.currentState!.reset();

    _sectorController.text = "";
    _specializationController.text = "";
  }

  void onJobSubmit() {
    setState(() {
      sector = JobDataFileService.sectors.firstWhereOrNull(
        (sector) => "${sector.id} - ${sector.name}" == _sectorController.text,
      );
      specialization = sector?.jobs.firstWhereOrNull(
        (job) => "${job.id} - ${job.name}" == _specializationController.text,
      );

      errorSector = null;
      errorSpecialization = null;
      if (sector == null) {
        errorSector = "Ce secteur n'existe pas";
      } else if (specialization == null &&
          _specializationController.text.isNotEmpty) {
        errorSpecialization = "Ce métier n'existe pas";
      }
    });

    questions = specialization?.questions ?? {};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CR-CRME Formulaire de stage"),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
            child: Column(
              children: [
                AutoCompleteField(
                  controller: _sectorController,
                  labelText: "Secteur d'activité",
                  errorText: errorSector,
                  onSubmit: onJobSubmit,
                  suggestions: [
                    ...JobDataFileService.sectors
                        .map((sector) => "${sector.id} - ${sector.name}")
                  ],
                ),
                AutoCompleteField(
                  controller: _specializationController,
                  labelText: "Métier",
                  errorText: errorSpecialization,
                  onSubmit: onJobSubmit,
                  suggestions: [
                    ...?sector?.jobs.map((job) => "${job.id} - ${job.name}")
                  ],
                ),
                ...questions.map((id) {
                  final question = QuestionFileService.fromId(id);
                  const isProfessor = true;

                  switch (question.type) {
                    case Type.radio:
                      return QuestionWithRadioBool(
                        choiceQuestion: question.getQuestion(isProfessor),
                        textTrue: question.choices.firstOrNull,
                        textFalse: question.choices.lastOrNull,
                        textQuestion: question.getTextQuestion(isProfessor),
                      );

                    case Type.checkbox:
                      return QuestionWithCheckboxList(
                        choicesQuestion: question.getQuestion(isProfessor),
                        choices: question.choices,
                        textQuestion: question.getTextQuestion(isProfessor),
                      );

                    case Type.text:
                      return QuestionWithText(
                        question: question.getQuestion(isProfessor),
                      );
                  }
                }),
                const SizedBox(height: 24),
                Visibility(
                  visible: questions.isNotEmpty,
                  child: ElevatedButton(
                    onPressed: _submit,
                    child: const Text("Soumettre"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
