import 'package:flutter/material.dart';

class QuestionWithCheckboxList extends StatefulWidget {
  const QuestionWithCheckboxList({
    this.visible = true,
    required this.choicesQuestion,
    required this.choices,
    this.initialChoices,
    this.onSavedChoices,
    this.textQuestion,
    this.initialText,
    this.onSavedText,
    super.key,
  });

  final bool visible;

  final String choicesQuestion;
  final Set<String> choices;
  final Set<String>? initialChoices;
  final void Function(Set<String>? choices)? onSavedChoices;

  final String? textQuestion;
  final String? initialText;
  final void Function(String? text)? onSavedText;

  @override
  State<QuestionWithCheckboxList> createState() =>
      _QuestionWithCheckboxListState();
}

class _QuestionWithCheckboxListState extends State<QuestionWithCheckboxList> {
  late final Map<String, bool> choices =
      Map.fromIterable(widget.choices, value: (_) => false);

  String _autre = "";

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.visible,
      child: Column(
        children: [
          Text(widget.choicesQuestion),
          FormField<Set<String>>(
            onSaved: widget.onSavedChoices,
            initialValue: widget.initialChoices ?? {},
            validator: (value) =>
                value!.isEmpty && _autre.isEmpty ? "Nop" : null,
            builder: (state) => Column(
              children: [
                ...widget.choices.map(
                  (choice) => CheckboxListTile(
                    title: Text(choice),
                    value: state.value!.contains(choice),
                    onChanged: (value) {
                      choices[choice] = value!;
                      if (value == true) {
                        state.didChange(state.value!.union({choice}));
                      } else {
                        state.didChange(state.value!.difference({choice}));
                      }
                    },
                  ),
                ),
                ListTile(
                  title: TextField(
                    decoration: const InputDecoration(labelText: "Autre :"),
                    onChanged: (text) => setState(() => _autre = text),
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible:
                (choices.values.any((c) => c == true) || _autre.isNotEmpty) &&
                    widget.textQuestion != null,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                children: [
                  Text(widget.textQuestion!),
                  TextFormField(
                    onSaved: widget.onSavedText,
                    initialValue: widget.initialText ?? "",
                    validator: (value) {
                      if (choices.values.any((c) => c == true) ||
                          _autre.isNotEmpty == true && value!.isEmpty) {
                        return "Nop";
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
