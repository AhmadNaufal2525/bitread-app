import 'package:flutter/material.dart';

class PasswordTextField extends StatefulWidget {
  final IconData icon;
  final String hintText;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String> onChanged;
  final String? initialValue;
  final TextEditingController? controller;

  const PasswordTextField({
    Key? key,
    required this.icon,
    required this.hintText,
    this.validator,
    this.initialValue,
    this.controller, required this.onChanged,
  }) : super(key: key);

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool obscureText = true;

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

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
            widget.icon,
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
              onChanged: widget.onChanged,
              controller: widget.controller,
              validator: widget.validator,
              obscureText: obscureText,
              decoration: InputDecoration(
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(
                      () {
                        obscureText = !obscureText;
                      },
                    );
                  },
                  child: Icon(
                    obscureText ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                ),
                hintText: widget.hintText,
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
