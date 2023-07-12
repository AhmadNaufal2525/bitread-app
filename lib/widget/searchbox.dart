import 'package:flutter/material.dart';

class SearchBox extends StatelessWidget {
  const SearchBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
              filled: true,
              fillColor: const Color.fromARGB(255, 228, 225, 225),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              hintText: "Cari Buku",
              hintStyle: const TextStyle(fontSize: 15),
              prefixIcon: const Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Icon(Icons.search),
              )),
        )
      ],
    );
  }
}
