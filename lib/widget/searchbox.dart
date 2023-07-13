import 'package:flutter/material.dart';

class SearchBox extends StatefulWidget {
  final Function(String) onSearch;

  const SearchBox({super.key, required this.onSearch});

  @override
  SearchBoxState createState() => SearchBoxState();
}

class SearchBoxState extends State<SearchBox> {
  TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: searchController,
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
              child: Icon(
                Icons.search,
                color: Colors.grey,
              ),
            ),
            suffixIcon: IconButton(
              onPressed: () {
                searchController.clear();
              },
              icon: const Icon(Icons.clear, color: Colors.grey),
            ),
          ),
          onSubmitted: (query) {
            widget.onSearch(query);
            searchController.clear();
          },
        )
      ],
    );
  }
}
