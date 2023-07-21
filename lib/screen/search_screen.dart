import 'package:bitread_app/screen/book_detail_screen.dart';
import 'package:bitread_app/screen/more_new_book.dart';
import 'package:bitread_app/screen/more_rating_book.dart';
import 'package:bitread_app/widget/card_book.dart';
import 'package:bitread_app/widget/searchbox.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchSreen extends StatefulWidget {
  const SearchSreen({super.key});

  @override
  State<SearchSreen> createState() => _SearchSreenState();
}

Future<List<Map<String, dynamic>>> fetchBooks() async {
  final collectionRef = FirebaseFirestore.instance.collection('Books');
  final querySnapshot = await collectionRef.get();
  return querySnapshot.docs
      .map((doc) => {
            'id': doc.id,
            'title': doc['title'],
            'imageUrl': doc['imageUrl'],
            'ebook': doc['ebook'],
            'author': doc['author'],
            'rating': doc['rating'],
            'description': doc['description'],
          })
      .toList();
}

List<String> searchResults = [];

class _SearchSreenState extends State<SearchSreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SearchBox(
                  onSearch: (query) {
                    setState(() {
                      searchResults.add(query);
                    });
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  'Pencarian Sebelumnya',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                ),
                const SizedBox(height: 16),
                searchResults.isEmpty
                    ? const Text(
                        'Riwayat Pencarian Tidak Ditemukan',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14),
                      )
                    : Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: searchResults.map(
                          (search) {
                            return InkWell(
                              onTap: () {},
                              child: Container(
                                height: 40,
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(60),
                                    border: Border.all(color: Colors.grey)),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      search,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.close,
                                          color: Colors.grey, size: 16),
                                      onPressed: () {
                                        setState(
                                          () {
                                            searchResults.remove(search);
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ).toList(),
                      ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Rating Teratas',
                      style:
                          TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RatingBook(),
                          ),
                        );
                      },
                      child: const Text(
                        'Lihat Semua',
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: fetchBooks(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    }

                    final List<Map<String, dynamic>>? books = snapshot.data;
                    return SizedBox(
                      height: 260,
                      child: ListView.separated(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 20),
                        itemCount: books!.length,
                        itemBuilder: (BuildContext context, int index) {
                          final book = books[index];
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BookDetailScreen(
                                      id: book['id'],
                                      title: book['title'],
                                      author: book['author'],
                                      rating: book['rating'].toString(),
                                      imageUrl: book['imageUrl'],
                                      desc: book['description']),
                                ),
                              );
                            },
                            child: BookCard(
                              title: book['title'],
                              author: book['author'],
                              rating: book['rating'],
                              imageUrl: book['imageUrl'],
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Buku Terbaru',
                      style:
                          TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NewBook(),
                          ),
                        );
                      },
                      child: const Text(
                        'Lihat Semua',
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: fetchBooks(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    }

                    final List<Map<String, dynamic>>? books = snapshot.data;
                    return SizedBox(
                      height: 260,
                      child: ListView.separated(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 20),
                        itemCount: books!.length,
                        itemBuilder: (BuildContext context, int index) {
                          final book = books[index];
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BookDetailScreen(
                                    id: book['id'],
                                    title: book['title'],
                                    author: book['author'],
                                    rating: book['rating'].toString(),
                                    imageUrl: book['imageUrl'],
                                    desc: book['description'],
                                  ),
                                ),
                              );
                            },
                            child: BookCard(
                              title: book['title'],
                              author: book['author'],
                              rating: book['rating'],
                              imageUrl: book['imageUrl'],
                            ),
                          );
                        },
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
