import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final IconData icon;
  final String hintText;
  final bool obscureText;

  const CustomTextField({
    Key? key,
    required this.icon,
    required this.hintText,
    this.obscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 20.0),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromARGB(255, 235, 231, 231)),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.grey,
          ),
          Expanded(
            child: SizedBox(
              height: 24.0, // Tinggi garis pemisah
              child: VerticalDivider(color: Colors.grey), // Garis pemisah
            ),
          ),
          Expanded(
            flex: 8,
            child: TextField(
              obscureText: obscureText,
              decoration: InputDecoration(
                  hintText: hintText,
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey)),
            ),
          ),
        ],
      ),
    );
  }
}
