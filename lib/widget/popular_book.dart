import 'package:bitread_app/provider/books_provider.dart';
import 'package:bitread_app/screen/book_detail_screen.dart';
import 'package:bitread_app/screen/more_popular_book.dart';
import 'package:bitread_app/widget/grid_card_book.dart';
import 'package:bitread_app/widget/grid_card_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PopularBook extends StatelessWidget {
  const PopularBook({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Buku Terpopuler',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PopularBookScreen(),
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
        const SizedBox(
          height: 20,
        ),
        StreamBuilder<List<Map<String, dynamic>>>(
  stream: Provider.of<BooksProvider>(context).fetchBooks(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return SizedBox(
        height: 320,
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
          ),
          itemCount: 4,
          itemBuilder: (BuildContext context, int index) {
            return const GridCardBookShimmer();
          },
        ),
      );
    }

    if (snapshot.hasError) {
      return Center(
        child: Text('Error: ${snapshot.error}'),
      );
    }

    final List<Map<String, dynamic>>? books = snapshot.data;
    if (books == null || books.isEmpty) {
      return const Center(
        child: Text('Tidak ada buku yang tersedia'),
      );
    }
    books.sort((a, b) => b['rating'].compareTo(a['rating']));

    return SizedBox(
      height: 320,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
        ),
        itemCount: books.length,
        itemBuilder: (BuildContext context, int index) {
          final book = books[index];
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookDetailScreen(
                      title: book['title'],
                      author: book['author'],
                      rating: book['rating'],
                      imageUrl: book['imageUrl'],
                      desc: book['description'],
                      id: book['id'],
                      url: book['url_book']),
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
      ),
    );
  },
),

      ],
    );
  }
}
