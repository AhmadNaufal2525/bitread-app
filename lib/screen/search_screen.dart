import 'package:bitread_app/screen/book_detail_screen.dart';
import 'package:bitread_app/screen/more_recom_book.dart';
import 'package:bitread_app/widget/card_book.dart';
import 'package:bitread_app/widget/searchbox.dart';
import 'package:flutter/material.dart';

class SearchSreen extends StatefulWidget {
  const SearchSreen({super.key});

  @override
  State<SearchSreen> createState() => _SearchSreenState();
}

final List<Map<String, dynamic>> books = [
  {
    'title': 'Be Modest, Be Social, Earn The Best',
    'author': 'Jenie Morgana',
    'rating': 4.5,
    'imageUrl': 'assets/book3.jpg',
  },
  {
    'title': 'Time To Explore',
    'author': 'Elie Kurien',
    'rating': 4.5,
    'imageUrl': 'assets/book2.jpg',
  },
  {
    'title': 'Different Winter',
    'author': 'Mia Jackson',
    'rating': 4.5,
    'imageUrl': 'assets/book1.jpg',
  },
  {
    'title': 'The Best tips for Design',
    'author': 'Ujang Lumajang',
    'rating': 4.0,
    'imageUrl': 'assets/book4.jpg',
  },
];

final List<String> lastSearches = [
  'Flutter',
  'Mobile',
  'Machine',
];

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
                const SearchBox(),
                const SizedBox(height: 20),
                const Text(
                  'Pencarian Sebelumnya',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: lastSearches.map(
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
                                      lastSearches.remove(search);
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
                            builder: (context) => const RecommendedBookScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Lihat Semua >>',
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 260,
                  child: ListView.separated(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 20),
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
                                rating: book['rating'].toString(),
                                imageUrl: book['imageUrl'],
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
                            builder: (context) => const RecommendedBookScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Lihat Semua >>',
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 260,
                  child: ListView.separated(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 20),
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
                                rating: book['rating'].toString(),
                                imageUrl: book['imageUrl'],
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
