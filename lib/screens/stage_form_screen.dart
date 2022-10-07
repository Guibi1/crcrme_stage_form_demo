import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

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

  String? errorSector;
  String? errorSpecialization;

  ActivitySector? activitySector;
  Specialization? specialization;
  Set<String> questions = {};

  bool isProfessor = true;

  Map<String, dynamic> awnser = {};
  String? awnserJson;

  void _submit() {
    if (activitySector == null || specialization == null) return;
    if (!FormService.validateForm(_formKey)) return;

    _formKey.currentState!.save();

    // TODO: Save data properly instead of displaying it
    setState(() {
      awnserJson = jsonEncode(awnser);
      awnser = {};
    });

    // _formKey.currentState!.reset();
  }

  void _onSectorChange(sector) {
    if (sector is ActivitySector) {
      activitySector = sector;
    } else if (sector is String) {
      activitySector = JobDataFileService.sectors.firstWhereOrNull(
        (s) => "${int.tryParse(s.id)} - ${s.name}" == sector,
      );
    } else {
      throw TypeError();
    }

    if (activitySector != null) {
      errorSector = null;
    } else {
      specialization = null;
    }

    questions = specialization?.questions ?? {};
    setState(() {});
  }

  void _onSpecializationChange(specialization) {
    if (specialization is Specialization) {
      this.specialization = specialization;
    } else if (specialization is String) {
      this.specialization = activitySector?.jobs.firstWhereOrNull(
        (s) => "${int.tryParse(s.id)} - ${s.name}" == specialization,
      );
    } else {
      throw TypeError();
    }

    if (this.specialization != null) {
      awnserJson = null;
      errorSpecialization = null;
    }

    questions = this.specialization?.questions ?? {};
    setState(() {});
  }

  void _testSectorValid() {
    setState(() {
      errorSector = activitySector == null ? "Ce secteur n'existe pas" : null;
    });
  }

  void _testSpecializationValid() {
    setState(() {
      if (specialization == null && activitySector != null) {
        errorSpecialization = "Ce métier n'existe pas";
      } else {
        errorSpecialization = null;
      }
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
                const ListTile(
                  title: Text("Les questions sont posés à :"),
                ),
                ListTileRadio(
                  titleLabel: "Personne de l'entreprise",
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
                Autocomplete<ActivitySector>(
                  displayStringForOption: (sector) =>
                      "${int.tryParse(sector.id)} - ${sector.name}",
                  optionsBuilder: (textEditingValue) {
                    int? number = int.tryParse(textEditingValue.text);
                    if (number != null) {
                      return JobDataFileService.sectors.where(
                        (sector) => sector.id.contains(number.toString()),
                      );
                    }
                    return JobDataFileService.sectors.where(
                      (suggestion) => suggestion.name
                          .toLowerCase()
                          .contains(textEditingValue.text.toLowerCase()),
                    );
                  },
                  onSelected: _onSectorChange,
                  fieldViewBuilder: (_, controller, focusNode, onSubmitted) {
                    focusNode.removeListener(_testSectorValid);
                    if (focusNode.hasPrimaryFocus) {
                      focusNode.addListener(_testSectorValid);
                    }

                    return TextField(
                      controller: controller,
                      focusNode: focusNode,
                      onSubmitted: (_) => onSubmitted(),
                      onChanged: _onSectorChange,
                      decoration: InputDecoration(
                        labelText: "Secteur d'activité",
                        errorText: errorSector,
                      ),
                    );
                  },
                ),
                Autocomplete<Specialization>(
                  displayStringForOption: (sector) =>
                      "${int.tryParse(sector.id)} - ${sector.name}",
                  optionsBuilder: (textEditingValue) {
                    if (activitySector == null) return [];
                    int? number = int.tryParse(textEditingValue.text);
                    if (number != null) {
                      return activitySector!.jobs.where(
                        (job) => job.id.contains(number.toString()),
                      );
                    }
                    return activitySector!.jobs.where(
                      (job) => job.name
                          .toLowerCase()
                          .contains(textEditingValue.text.toLowerCase()),
                    );
                  },
                  onSelected: _onSpecializationChange,
                  fieldViewBuilder: (_, controller, focusNode, onSubmitted) {
                    focusNode.removeListener(_testSpecializationValid);
                    if (focusNode.hasPrimaryFocus) {
                      focusNode.addListener(_testSpecializationValid);
                    }

                    return TextField(
                      enabled: activitySector != null,
                      controller: controller,
                      focusNode: focusNode,
                      onSubmitted: (_) => onSubmitted(),
                      onChanged: _onSpecializationChange,
                      decoration: InputDecoration(
                        labelText: "Métier",
                        errorText: errorSpecialization,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: questions.length,
                  itemBuilder: (context, index) {
                    String id = questions.elementAt(index);
                    final question = QuestionFileService.fromId(id);

                    switch (question.type) {
                      case Type.radio:
                        return QuestionWithRadioBool(
                          choiceQuestion:
                              "${index + 1}. ${question.getQuestion(isProfessor)}",
                          textTrue: question.choices.firstOrNull,
                          textFalse: question.choices.lastOrNull,
                          textQuestion: question.getTextQuestion(isProfessor),
                          onSavedChoice: (choice) =>
                              awnser[question.id] = choice,
                          onSavedText: (text) =>
                              awnser["${question.id}+t"] = text,
                        );

                      case Type.checkbox:
                        return QuestionWithCheckboxList(
                          choicesQuestion:
                              "${index + 1}. ${question.getQuestion(isProfessor)}",
                          choices: question.choices,
                          textQuestion: question.getTextQuestion(isProfessor),
                          onSavedChoices: (choices) =>
                              awnser[question.id] = choices?.toList(),
                          onSavedText: (text) =>
                              awnser["${question.id}+t"] = text,
                        );

                      case Type.text:
                        return QuestionWithText(
                          question:
                              "${index + 1}. ${question.getQuestion(isProfessor)}",
                          onSaved: (text) => awnser[question.id] = text,
                        );
                    }
                  },
                ),
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
