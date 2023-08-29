import 'package:bitread_app/provider/books_provider.dart';
import 'package:bitread_app/screen/book_detail_screen.dart';
import 'package:bitread_app/widget/grid_card_book.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewBook extends StatefulWidget {
  const NewBook({super.key});

  @override
  State<NewBook> createState() => _NewBookState();
}

class _NewBookState extends State<NewBook> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Buku Terbaru',
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
                    books?.sort(
                        (a, b) => b['uploadTime'].compareTo(a['uploadTime']));
                    final now = DateTime.now();
                    final cutoffDate = now.subtract(const Duration(days: 7));
                    final newBooks = books?.where((book) =>
                            book['uploadTime'].toDate().isAfter(cutoffDate)) ??
                        [];

                    if (newBooks.isEmpty) {
                      return const Center(
                        child: Text('Belum ada buku terbaru'),
                      );
                    }
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
