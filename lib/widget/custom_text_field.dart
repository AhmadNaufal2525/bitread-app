import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final IconData icon;
  final String hintText;
  final bool obscureText;
  final FormFieldValidator<String>? validator;
  final String? initialValue;
  final TextEditingController? controller;

  const CustomTextField({
    Key? key,
    required this.icon,
    required this.hintText,
    this.obscureText = false,
    this.validator,
    this.initialValue,
    this.controller, required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromARGB(255, 235, 231, 231)),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.grey,
          ),
          const Expanded(
            child: SizedBox(
              height: 24.0,
              child: VerticalDivider(color: Colors.grey),
            ),
          ),
          Expanded(
            flex: 8,
            child: TextFormField(
              onChanged: onChanged,
              controller: controller,
              validator: validator,
              obscureText: obscureText,
              decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
                hintStyle: const TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
