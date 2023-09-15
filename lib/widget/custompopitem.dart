import 'package:flutter/material.dart';

class CustomPopupMenuItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String text;
  final VoidCallback onTap;
  final double iconSize; 
  final double textSize; 

  const CustomPopupMenuItem({
    Key? key,
    required this.icon,
    required this.iconColor,
    required this.text,
    required this.onTap,
    this.iconSize = 24.0, 
    this.textSize = 16.0, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon(
              icon,
              color: iconColor,
              size: iconSize, 
            ),
            const SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                fontSize: textSize,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
