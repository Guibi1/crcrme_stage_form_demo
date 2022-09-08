import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';

class AutoCompleteField extends StatelessWidget {
  const AutoCompleteField({
    super.key,
    this.controller,
    required this.labelText,
    this.errorText,
    required this.onSubmit,
    required this.suggestions,
  });

  final TextEditingController? controller;
  final String labelText;
  final String? errorText;
  final Function() onSubmit;
  final List<String> suggestions;

  @override
  Widget build(BuildContext context) {
    return AutoCompleteTextField<String>(
      key: GlobalKey(),
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        errorText: errorText,
      ),
      textSubmitted: (_) => onSubmit(),
      itemSubmitted: (_) => onSubmit(),
      clearOnSubmit: false,
      suggestions: suggestions,
      itemBuilder: (context, suggestion) => ListTile(title: Text(suggestion)),
      itemSorter: (a, b) => a.compareTo(b),
      minLength: 0,
      itemFilter: (suggestion, query) =>
          suggestion.toString().toLowerCase().startsWith(
                query.toLowerCase(),
              ),
    );
  }
}
