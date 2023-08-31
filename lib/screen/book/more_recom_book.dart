import 'package:bitread_app/provider/books_provider.dart';
import 'package:bitread_app/screen/book/book_detail_screen.dart';
import 'package:bitread_app/widget/grid_card_book.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecommendedBookScreen extends StatefulWidget {
  const RecommendedBookScreen({super.key});

  @override
  State<RecommendedBookScreen> createState() => _RecommendedBookScreenState();
}

class _RecommendedBookScreenState extends State<RecommendedBookScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        title: const Text(
          'Rekomendasi Buku',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: StreamBuilder<List<Map<String, dynamic>>>(
                  stream: Provider.of<BooksProvider>(context).fetchBooks(),
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
                    return GridView.builder(
                      scrollDirection: Axis.vertical,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
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
                                  rating: book['rating'],
                                  imageUrl: book['imageUrl'],
                                  desc: book['description'],
                                  url: book['url_book'],
                                ),
                              ),
                            );
                          },
                          child: GridCardBook(
                            title: book['title'],
                            author: book['author'],
                            rating: book['rating'],
                            imageUrl: book['imageUrl'],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
