import 'package:collection/collection.dart';
import 'package:crcrme_stage_form_demo/common/widgets/autocomplete_field.dart';
import 'package:crcrme_stage_form_demo/misc/form_service.dart';
import 'package:flutter/material.dart';

import '/common/widgets/question_with_checkbox_list.dart';
import '/common/widgets/question_with_radio_bool.dart';
import '/common/widgets/question_with_text.dart';
import '/misc/job_data_file_service.dart';

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
                  suggestions: JobDataFileService.sectors
                      .map((sector) => "${sector.id} - ${sector.name}")
                      .toList(),
                ),
                AutoCompleteField(
                  controller: _specializationController,
                  labelText: "Spécialisation",
                  errorText: errorSpecialization,
                  onSubmit: onJobSubmit,
                  suggestions: sector?.jobs
                          .map((job) => "${job.id} - ${job.name}")
                          .toList() ??
                      [],
                ),
                QuestionWithRadioBool(
                  visible: questions.contains("1"),
                  textTrue: "Debout",
                  textFalse: "Assis",
                  choiceQuestion:
                      "Est-ce que l’élève travaille majoritairement : ",
                  textQuestion:
                      "Est-ce qu’il y a des endroits où l’élève peut s’assoir?",
                ),
                QuestionWithRadioBool(
                  visible: questions.contains("2"),
                  choiceQuestion:
                      "Est-ce que l’élève doit porter des boites de marchandises ou d’autres produits?",
                  textQuestion:
                      "Est-ce que cela se produit souvent? Est-ce que vous pouvez me montrer de quel type de boites il s’agit?",
                ),
                QuestionWithRadioBool(
                  visible: questions.contains("3"),
                  choiceQuestion:
                      "Est-ce que l’élève est amené à porter les enfants?",
                  textQuestion: "Est-ce que cela se produit souvent?",
                ),
                QuestionWithRadioBool(
                  visible: questions.contains("4"),
                  choiceQuestion:
                      "Est-ce que l’élève est amené à porter les animaux?",
                  textQuestion: "Est-ce que cela se produit souvent?",
                ),
                QuestionWithCheckboxList(
                  visible: questions.contains("5"),
                  choicesQuestion:
                      "Est-ce que l’élève doit déplacer des marchandises, par exemple avec :",
                  choices: const {"Un diable", "Un transpalette", "Un chariot"},
                  textQuestion:
                      "Mon élève n’a jamais utilisé ce type d’équipement auparavant. Est-ce que vous ou un collègue pourrait prendre quelques minutes pour lui expliquer comment s’en servir (comment pousser, tirer, charger, décharger, circuler, …)",
                ),
                QuestionWithCheckboxList(
                  visible: questions.contains("6"),
                  choicesQuestion:
                      "Est-ce que l’élève doit travailler en hauteur et utiliser :",
                  choices: const {"Un escabeau", "Une échelle"},
                  textQuestion:
                      "Mon élève n’a jamais travaillé avec ce genre d’équipement, est-ce que vous pourriez lui montrer comment s’en servir?",
                ),
                QuestionWithCheckboxList(
                  visible: questions.contains("7"),
                  choicesQuestion:
                      "Est-ce que l’élève doit utiliser un outil coupant, par exemple pour couper des produits ou pour ouvrir des boites comme:",
                  choices: const {
                    "Un couteau",
                    "Un couteau à lame rétractable (Exacto)",
                    "Des ciseaux",
                    "Une scie",
                  },
                  textQuestion:
                      "Mon élève n’a jamais travaillé avec ce genre d’équipement, est-ce que vous pourriez lui montrer comment s’en servir?",
                ),
                QuestionWithCheckboxList(
                  visible: questions.contains("8"),
                  choicesQuestion:
                      "Est-ce que l’élève doit travailler dans un environnement où :",
                  choices: const {"Chaud", "Froid"},
                  textQuestion:
                      "Est-ce qu’il y a des équipements de protection prévus? Est-ce qu’il y a des choses que mon élève doit savoir par rapport à ça? ",
                ),
                QuestionWithRadioBool(
                  visible: questions.contains("9"),
                  choiceQuestion:
                      "Est-ce que l’élève fait du service à la clientèle ?",
                  textQuestion:
                      "Est-ce qu’il y a déjà eu des clients mécontents ou qui se sont mal comportés avec les employés? Comment je peux y préparer mon élève?",
                ),
                QuestionWithCheckboxList(
                  visible: questions.contains("10"),
                  choicesQuestion:
                      "Est-ce que l’élève utilise ou travaille à proximité de produits chimiques comme :",
                  choices: const {
                    "Aérosols",
                    "Produits de nettoyage",
                    "Produits phytosanitaires (pesticides)"
                  },
                  textQuestion:
                      "Est-ce que vous devez suivre une procédure particulière par rapport à ces produits ou porter des équipements spécifiques? Lesquels?",
                ),
                QuestionWithCheckboxList(
                  visible: questions.contains("11"),
                  choicesQuestion:
                      "Est-ce que l’élève utilise ou travaille à proximité de produits chimiques comme :",
                  choices: const {
                    "Aérosols",
                    "Produits de nettoyage",
                    "Produits pour la teinture",
                  },
                  textQuestion:
                      "Est-ce que vous devez suivre une procédure particulière par rapport à ces produits ou porter des équipements spécifiques? Lesquels?",
                ),
                QuestionWithCheckboxList(
                  visible: questions.contains("12"),
                  choicesQuestion:
                      "Est-ce que l’élève utilise ou travaille à proximité de produits chimiques comme :",
                  choices: const {
                    "Aérosols",
                    "Produits de nettoyage",
                    "Solvants",
                    "Vernis",
                  },
                  textQuestion:
                      "Est-ce que vous devez suivre une procédure particulière par rapport à ces produits ou porter des équipements spécifiques? Lesquels?",
                ),
                QuestionWithRadioBool(
                  visible: questions.contains("13"),
                  choiceQuestion:
                      "Est-ce que l’élève aura à porter des gants ?",
                  textQuestion:
                      "Est-ce que ce sont uniquement des gants en latex ou il y en a dans d’autres matière ? C’est au cas où mon élève serait allergique",
                ),
                QuestionWithCheckboxList(
                  visible: questions.contains("14"),
                  choicesQuestion:
                      "Est-ce que l’élève sera en contact avec des allergènes tels que :",
                  choices: const {
                    "En manipulant de la farine",
                    "En portant des gants en latex",
                  },
                  textQuestion:
                      "Est-ce que vous devez suivre une procédure particulière par rapport à ces produits ou porter des équipements spécifiques? Lesquels?",
                ),
                QuestionWithCheckboxList(
                  visible: questions.contains("15"),
                  choicesQuestion:
                      "Est-ce que l’élève sera en contact avec des allergènes tels que :",
                  choices: const {
                    "Poussière de bois",
                    "Gants en latex",
                  },
                  textQuestion:
                      "Est-ce que vous devez suivre une procédure particulière par rapport à ces produits ou porter des équipements spécifiques? Lesquels?",
                ),
                QuestionWithCheckboxList(
                  visible: questions.contains("16"),
                  choicesQuestion:
                      "Est-ce que l'élève devra utiliser des outils à main comme :",
                  choices: const {"Une perceuse", "Une polisseuse"},
                  textQuestion:
                      "Mon élève n’a jamais travaillé avec ce genre d’équipement, est-ce que vous pourriez lui montrer comment s’en servir? Est-ce qu’il y a des choses pour réduire la vibration dans la main et le bras lors de l’utilisation de l’outil?",
                ),
                QuestionWithRadioBool(
                  visible: questions.contains("17"),
                  choiceQuestion:
                      "Est-ce que mon élève doit faire attention à des choses particulières pendant l’assemblage des pièces ou la soudure?",
                ),
                QuestionWithRadioBool(
                  visible: questions.contains("18"),
                  choiceQuestion:
                      "Quelles sont les choses que mon élève doit savoir pour que cela se passe bien avec les animaux et qu’il ou elle ne se fasse pas mordre, griffer et ne reçoive pas de coups?",
                ),
                QuestionWithCheckboxList(
                  visible: questions.contains("19"),
                  choicesQuestion:
                      "Est-ce que l’élève doit travailler dans un environnement où :",
                  choices: const {"Il y a du bruit", "Il y a de la poussière"},
                  textQuestion:
                      "Est-ce qu’il y a des équipements de protection prévus? Est-ce qu’il y a des choses que mon élève doit savoir par rapport à ça? ",
                ),
                QuestionWithCheckboxList(
                  visible: questions.contains("20"),
                  choicesQuestion: "Est-ce que l'élève :",
                  choices: const {
                    "Conduira un tracteur?"
                        "Travaillera dans un silo?",
                    "Devra nettoyer des box / enclos d’animaux?",
                    "Interagira avec des animaux (les déplacer, les monter, les soigner…)?",
                  },
                  textQuestion:
                      "Est-ce que les employés doivent suivre une procédure particulière ou porter des équipements spécifiques pour ça? ",
                ),
                QuestionWithCheckboxList(
                  visible: questions.contains("21"),
                  choicesQuestion: "Est-ce que l'élève :",
                  choices: const {
                    "Devra nettoyer des box / enclos d’animaux?",
                    "Interagira avec des animaux (les déplacer, les monter, les soigner…)?",
                  },
                  textQuestion:
                      "Est-ce que les employés doivent suivre une procédure particulière ou porter des équipements spécifiques pour ça?",
                ),
                QuestionWithText(
                  visible: questions.contains("22"),
                  question:
                      "Quel est le plus grand défi pour le service aux tables? Quelles sont les choses à apprendre pour ne pas renverser les plats ni pour se brûler avec les plats?",
                ),
                QuestionWithRadioBool(
                  visible: questions.contains("23"),
                  choiceQuestion:
                      "Est-ce qu’il y a déjà eu des incidents ou des accidents du travail au poste que l’élève occupera en stage?",
                  textQuestion: "Pouvez-vous me raconter ce qu’il s’est passé?",
                ),
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
