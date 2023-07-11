import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GoogleButton extends StatelessWidget {
  final String text;
  final Function() press;
  final Color? color, textColor;
  final double? height;
  const GoogleButton({
    Key? key,
    required this.text,
    required this.press,
    this.color,
    this.textColor,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double buttonHeight = height ?? size.height * 0.07;
    return ElevatedButton(
      onPressed: press,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: BorderSide(color: Colors.grey)),
        padding: const EdgeInsets.symmetric(
          horizontal: 40,
        ),
        textStyle: GoogleFonts.poppins(
          color: color,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        minimumSize: Size(size.width, buttonHeight),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Image.asset(
            'assets/google.png',
            width: 36,
            height: 36,
          ),
          const SizedBox(
            width: 46,
          ),
          Text(
            text,
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
