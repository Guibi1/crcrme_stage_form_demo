import 'package:flutter/material.dart';

class QuestionWithRadioBool extends StatefulWidget {
  const QuestionWithRadioBool({
    this.visible = true,
    required this.choiceQuestion,
    this.initialChoice,
    this.onSavedChoice,
    this.textQuestion,
    this.initialText,
    this.onSavedText,
    super.key,
  });

  final bool visible;

  final String choiceQuestion;
  final bool? initialChoice;
  final void Function(bool? choice)? onSavedChoice;

  final String? textQuestion;
  final String? initialText;
  final void Function(String? text)? onSavedText;

  @override
  State<QuestionWithRadioBool> createState() => _QuestionWithRadioBoolState();
}

class _QuestionWithRadioBoolState extends State<QuestionWithRadioBool> {
  bool? choice;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.visible,
      child: Column(
        children: [
          Text(widget.choiceQuestion),
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
          Visibility(
            visible: choice == true && widget.textQuestion != null,
            child: Column(
              children: [
                Text(widget.textQuestion!),
                TextFormField(
                  onSaved: widget.onSavedText,
                  initialValue: widget.initialText ?? "",
                  validator: (value) =>
                      choice == true && value!.isEmpty ? "Nop" : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
