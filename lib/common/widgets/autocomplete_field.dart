import 'package:flutter/material.dart';

class AutocompleteField<T extends Object> extends StatelessWidget {
  const AutocompleteField({
    super.key,
    required this.displayStringForOption,
    required this.optionsBuilder,
    required this.onSelected,
    required this.labelText,
    required this.errorText,
    required this.onChanged,
    required this.testChoiceIsValid,
    this.enabled = true,
  });

  final Function(dynamic) onSelected;
  final Iterable<T> Function(TextEditingValue) optionsBuilder;
  final String Function(T) displayStringForOption;
  final String labelText;
  final String? errorText;
  final void Function(String) onChanged;
  final void Function() testChoiceIsValid;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Autocomplete<T>(
      displayStringForOption: displayStringForOption,
      optionsBuilder: optionsBuilder,
      onSelected: onSelected,
      fieldViewBuilder: (_, controller, focusNode, onSubmitted) {
        focusNode.removeListener(testChoiceIsValid);
        if (focusNode.hasPrimaryFocus) {
          focusNode.addListener(testChoiceIsValid);
        }
        return TextField(
          enabled: enabled,
          controller: controller,
          focusNode: focusNode,
          onSubmitted: (_) => onSubmitted(),
          onChanged: onChanged,
          decoration: InputDecoration(
            labelText: labelText,
            errorText: errorText,
          ),
        );
      },
    );
  }
}
