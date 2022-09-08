import 'package:flutter/material.dart';

import '/common/widgets/question_with_text.dart';

class QuestionWithRadioBool extends StatefulWidget {
  const QuestionWithRadioBool({
    this.visible = true,
    this.textTrue = "Oui",
    this.textFalse = "Non",
    required this.choiceQuestion,
    this.initialChoice,
    this.onSavedChoice,
    this.textQuestion,
    this.initialText,
    this.onSavedText,
    super.key,
  });

  final bool visible;
  final String textTrue;
  final String textFalse;

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
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.choiceQuestion),
            const SizedBox(height: 8),
            FormField<bool?>(
              onSaved: widget.onSavedChoice,
              initialValue: widget.initialChoice,
              validator: (value) => value == null ? "Nop" : null,
              builder: (state) => Row(
                children: [
                  Radio(
                    value: true,
                    groupValue: state.value,
                    onChanged: (value) {
                      state.didChange(value);
                      setState(() => choice = value);
                    },
                  ),
                  Text(widget.textTrue),
                  const SizedBox(width: 16),
                  Radio(
                    value: false,
                    groupValue: state.value,
                    onChanged: (value) {
                      state.didChange(value);
                      setState(() => choice = value);
                    },
                  ),
                  Text(widget.textFalse),
                ],
              ),
            ),
            QuestionWithText(
              visible: choice == true,
              question: widget.textQuestion ?? "",
              onSaved: widget.onSavedText,
              initialValue: widget.initialText ?? "",
              validator: (value) =>
                  choice == true && value!.isEmpty ? "Nop" : null,
            ),
          ],
        ),
      ),
    );
  }
}
