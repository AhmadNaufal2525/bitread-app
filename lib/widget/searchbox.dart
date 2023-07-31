import 'package:flutter/material.dart';

class SearchBox extends StatefulWidget {
  final Function(String) onSearch;

  const SearchBox({Key? key, required this.onSearch}) : super(key: key);

  @override
  SearchBoxState createState() => SearchBoxState();
}

class SearchBoxState extends State<SearchBox> {
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();

  @override
  void dispose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: searchController,
          focusNode: searchFocusNode,
          onChanged: (query) {
            setState(() {});
          },
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
            suffixIcon: searchController.text.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      searchController.clear();
                    },
                    icon: const Icon(Icons.clear, color: Colors.grey),
                  )
                : null,
          ),
          onSubmitted: (query) {
            widget.onSearch(query);
            searchController.clear();
          },
          onTap: () {
            setState(() {
              searchFocusNode.requestFocus();
            });
          },
          onEditingComplete: () {
            setState(() {
              searchFocusNode.unfocus();
            });
          },
        )
      ],
    );
  }
}
