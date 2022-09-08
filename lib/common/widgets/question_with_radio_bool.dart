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

  void _setChoice(FormFieldState<bool?> state, bool? value) {
    state.didChange(value);
    setState(() => choice = value);
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.visible,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.choiceQuestion,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            FormField<bool?>(
              onSaved: widget.onSavedChoice,
              initialValue: widget.initialChoice,
              validator: (value) => value == null ? "Nop" : null,
              builder: (state) => Column(
                children: [
                  InkWell(
                    onTap: () => _setChoice(state, true),
                    child: ListTile(
                      leading: Radio(
                        value: true,
                        groupValue: state.value,
                        onChanged: (value) => _setChoice(state, value),
                      ),
                      title: Text(widget.textTrue),
                    ),
                  ),
                  InkWell(
                    onTap: () => _setChoice(state, false),
                    child: ListTile(
                      leading: Radio(
                        value: false,
                        groupValue: state.value,
                        onChanged: (value) => _setChoice(state, value),
                      ),
                      title: Text(widget.textFalse),
                    ),
                  ),
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
