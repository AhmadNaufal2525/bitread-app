import 'package:bitread_app/provider/books_provider.dart';
import 'package:bitread_app/screen/book_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchResultScreen extends StatelessWidget {
  final String searchQuery;

  const SearchResultScreen({super.key, required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: Colors.transparent,
          actions: [
            Align(
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.close,
                  color: Colors.black,
                ),
              ),
            )
          ],
          centerTitle: true,
          title: const Text(
            'Hasil Pencarian',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          pinned: true,
          floating: false,
        ),
        SliverPadding(
          padding: const EdgeInsets.all(8),
          sliver: StreamBuilder<List<Map<String, dynamic>>>(
            stream: Provider.of<BooksProvider>(context).searchBooks(searchQuery),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (snapshot.hasError) {
                return SliverFillRemaining(
                  child: Center(
                    child: Text('Error: ${snapshot.error}'),
                  ),
                );
              }

              final List<Map<String, dynamic>>? books = snapshot.data;
              if (books == null || books.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(
                    child: Text(
                      'Buku Tidak Ditemukan',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                );
              }

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
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
                              url : book['url_book']
                            ),
                          ),
                        );
                      },
                      child: ListTile(
                        isThreeLine: true,
                        leading: Image.network(
                          book['imageUrl'],
                          width: 40,
                          fit: BoxFit.fitWidth,
                        ),
                        title: Text(
                          book['title'],
                          style: const TextStyle(fontSize: 12),
                        ),
                        subtitle: Text(
                          book['author'],
                          style: const TextStyle(fontSize: 13),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.orange,
                              size: 18,
                            ),
                            Text(
                              book['rating'].toString(),
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: books.length,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
