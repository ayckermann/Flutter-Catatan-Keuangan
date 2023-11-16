import 'package:catatan_keuangan/tools/styles.dart';
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

class ButtonAuth extends StatelessWidget {
  const ButtonAuth({
    super.key,
    required this.label,
    required this.onPressed,
    required this.fgColor,
    required this.bgColor,
  });

  final String label;
  final Function onPressed;
  final Color fgColor;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onPressed();
      },
      style: ElevatedButton.styleFrom(
          foregroundColor: fgColor,
          backgroundColor: bgColor,
          shape: RoundedRectangleBorder(
              side: BorderSide(color: headerColor, width: 1),
              borderRadius: BorderRadius.circular(5))),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 5),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins-bold',
          ),
        ),
      ),
    );
  }
}
