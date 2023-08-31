import 'package:bitread_app/provider/books_provider.dart';
import 'package:bitread_app/screen/book/book_detail_screen.dart';
import 'package:bitread_app/screen/book/more_recom_book.dart';
import 'package:bitread_app/widget/card_book.dart';
import 'package:bitread_app/widget/card_book_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecomBook extends StatelessWidget {
  const RecomBook({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Rekomendasi Buku',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RecommendedBookScreen(),
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
        StreamBuilder<List<Map<String, dynamic>>>(
          stream: Provider.of<BooksProvider>(context).fetchBooks(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(
                height: 260,
                child: ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 20),
                  itemCount: 5,
                  itemBuilder: (BuildContext context, int index) {
                    return const CardBookShimmer();
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

            return SizedBox(
              height: 260,
              child: ListView.separated(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                separatorBuilder: (context, index) => const SizedBox(width: 20),
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
      ],
    );
  }
}
