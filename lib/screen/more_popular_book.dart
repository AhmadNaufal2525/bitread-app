import 'package:bitread_app/screen/book_detail_screen.dart';
import 'package:bitread_app/widget/popular_book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PopularBookScreen extends StatefulWidget {
  const PopularBookScreen({super.key});

  @override
  State<PopularBookScreen> createState() => _PopularBookScreenState();
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

class _PopularBookScreenState extends State<PopularBookScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 80),
                  child: Text(
                    'Buku Terpopuler',
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                  ),
                )
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: FutureBuilder<List<Map<String, dynamic>>>(
                          future: fetchBooks(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            if (snapshot.hasError) {
                              return Center(
                                child: Text('Error: ${snapshot.error}'),
                              );
                            }

                            final List<Map<String, dynamic>>? books =
                                snapshot.data;
                return GridView.builder(
                  scrollDirection: Axis.vertical,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.0,
                  ),
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
                      child: PopularBook(
                        title: book['title'],
                        author: book['author'],
                        rating: book['rating'],
                        imageUrl: book['imageUrl'],
                      ),
                    );
                  },
                );}
              ),
            ),
        ),],
        ),
      ),
    );
  }
}
