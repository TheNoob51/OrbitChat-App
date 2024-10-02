import 'package:flutter/material.dart';

class TextFieldForLogin extends StatelessWidget {
  const TextFieldForLogin({
    super.key,
    required this.label,
    required this.iconfor,
    required this.textEditingController,
    required this.isPass,
    // required this.textInputType,
  });

  final String label;
  final IconData iconfor;
  final TextEditingController textEditingController;
  final bool isPass;
  // final TextInputType textInputType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: isPass,
      controller: textEditingController,
      onTapOutside: (event) {
        FocusScope.of(context).unfocus();
      },
      decoration: InputDecoration(
        prefixIcon: Icon(iconfor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey[200],
        labelText: label,
      ),
    );
  }
}
