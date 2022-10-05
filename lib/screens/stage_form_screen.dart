import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '/common/widgets/autocomplete_field.dart';
import '/common/widgets/list_tile_radio.dart';
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
  List<String> questions = [];

  bool isProfessor = true;

  Map<String, dynamic> awnser = {};
  String? awnserJson;

  void _submit() {
    if (sector == null || specialization == null) return;
    if (!FormService.validateForm(_formKey)) return;

    _formKey.currentState!.save();

    setState(() {
      awnserJson = jsonEncode(awnser);
      awnser = {};
    });

    // _sectorController.text = "";
    // _specializationController.text = "";

    // _formKey.currentState!.reset();
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

      questions = specialization?.questions.toList() ?? [];
      awnserJson = null;
    });
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
                ListTileRadio(
                  titleLabel: "Professeur",
                  value: true,
                  groupValue: isProfessor,
                  onChanged: (value) => setState(() => isProfessor = value!),
                ),
                ListTileRadio(
                  titleLabel: "Élève",
                  value: false,
                  groupValue: isProfessor,
                  onChanged: (value) => setState(() => isProfessor = value!),
                ),
                const SizedBox(height: 24),
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
                const SizedBox(height: 24),
                ...questions.map((id) {
                  final question = QuestionFileService.fromId(id);
                  final i = questions.indexOf(id) + 1;

                  switch (question.type) {
                    case Type.radio:
                      return QuestionWithRadioBool(
                        choiceQuestion:
                            "$i. ${question.getQuestion(isProfessor)}",
                        textTrue: question.choices.firstOrNull,
                        textFalse: question.choices.lastOrNull,
                        textQuestion: question.getTextQuestion(isProfessor),
                        onSavedChoice: (choice) => awnser[question.id] = choice,
                        onSavedText: (text) =>
                            awnser["${question.id}+t"] = text,
                      );

                    case Type.checkbox:
                      return QuestionWithCheckboxList(
                        choicesQuestion:
                            "$i. ${question.getQuestion(isProfessor)}",
                        choices: question.choices,
                        textQuestion: question.getTextQuestion(isProfessor),
                        onSavedChoices: (choices) =>
                            awnser[question.id] = choices?.toList(),
                        onSavedText: (text) =>
                            awnser["${question.id}+t"] = text,
                      );

                    case Type.text:
                      return QuestionWithText(
                        question: "$i. ${question.getQuestion(isProfessor)}",
                        onSaved: (text) => awnser[question.id] = text,
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
                Visibility(
                  visible: awnserJson != null,
                  child: TextField(
                    controller: TextEditingController(text: awnserJson),
                    minLines: 1,
                    maxLines: 20,
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
