import 'package:flutter/material.dart';

class CategorieTile extends StatefulWidget {
  final String text;
  final bool isSelected;
  const CategorieTile(
      {super.key, required this.text, required this.isSelected});

  @override
  State<CategorieTile> createState() => _CategorieTileState();
}

class _CategorieTileState extends State<CategorieTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(right: 12),
            child: Text(
              widget.text,
              style: TextStyle(
                  color: widget.isSelected ? Colors.black87 : Colors.grey,
                  fontWeight:
                      widget.isSelected ? FontWeight.w600 : FontWeight.w400,
                  fontSize: widget.isSelected ? 23 : 18),
            ),
          ),
          const SizedBox(height: 3),
          widget.isSelected
              ? Container(
                  height: 3,
                  width: 16,
                  decoration: BoxDecoration(
                      color: const Color(0xff007084),
                      borderRadius: BorderRadius.circular(12)),
                )
              : Container(),
        ],
      ),
    );
  }
}
