import 'package:flutter/material.dart';

class UserField extends StatelessWidget {
  final String label;
  final TextInputType inputType;
  final TextEditingController controller;
  final IconData icon;

  UserField({
    required this.label,
    required this.controller,
    required this.inputType,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      autocorrect: false,
      keyboardType: inputType,
      controller: controller,
      decoration: InputDecoration(prefixIcon: Icon(icon), labelText: label),
    );
  }
}

class PasswordField extends UserField {
  final bool passVisible;
  final Function() visPresed;

  PasswordField(
      {required super.label,
      required super.controller,
      super.inputType = TextInputType.visiblePassword,
      super.icon = Icons.lock,
      required this.passVisible,
      required this.visPresed});

  @override
  Widget build(BuildContext context) {
    return TextField(
      autocorrect: false,
      keyboardType: inputType,
      obscureText: passVisible,
      controller: controller,
      decoration: InputDecoration(
        label: Text(label),
        prefixIcon: Icon(icon),
        suffixIcon: IconButton(
            icon: Icon(passVisible ? Icons.visibility : Icons.visibility_off),
            onPressed: visPresed),
        alignLabelWithHint: false,
      ),
      style: TextStyle(fontSize: 16),
    );
  }
}
