import 'package:flutter/material.dart';

class QuestionWithRadioBool extends StatefulWidget {
  const QuestionWithRadioBool({
    required this.choiceQuestion,
    this.initialChoice,
    this.onSavedChoice,
    required this.textQuestion,
    this.initialText,
    this.onSavedText,
    super.key,
  });

  final Widget choiceQuestion;
  final bool? initialChoice;
  final void Function(bool? choice)? onSavedChoice;

  final Widget textQuestion;
  final String? initialText;
  final void Function(String? text)? onSavedText;

  @override
  State<QuestionWithRadioBool> createState() => _QuestionWithRadioBoolState();
}

class _QuestionWithRadioBoolState extends State<QuestionWithRadioBool> {
  bool? choice;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.choiceQuestion,
        FormField<bool?>(
          onSaved: widget.onSavedChoice,
          initialValue: widget.initialChoice,
          validator: (value) => value == null ? "Nop" : null,
          builder: (state) => Row(
            children: [
              const Text("Oui"),
              Radio(
                value: true,
                groupValue: state.value,
                onChanged: (value) {
                  state.didChange(value);
                  setState(() => choice = value);
                },
              ),
              const Text("Non"),
              Radio(
                value: false,
                groupValue: state.value,
                onChanged: (value) {
                  state.didChange(value);
                  setState(() => choice = value);
                },
              ),
            ],
          ),
        ),
        FormField<String>(
          onSaved: widget.onSavedText,
          initialValue: widget.initialText ?? "",
          validator: (value) => choice == true && value!.isEmpty ? "Nop" : null,
          builder: (state) => Visibility(
            visible: choice == true,
            child: Column(
              children: [
                widget.textQuestion,
                // awnser,
              ],
            ),
          ),
        ),
      ],
    );
  }
}
