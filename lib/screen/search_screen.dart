import 'package:bitread_app/provider/books_provider.dart';
import 'package:bitread_app/screen/book_detail_screen.dart';
import 'package:bitread_app/screen/more_new_book.dart';
import 'package:bitread_app/screen/more_rating_book.dart';
import 'package:bitread_app/screen/search_result_screen.dart';
import 'package:bitread_app/widget/card_book.dart';
import 'package:bitread_app/widget/card_book_shimmer.dart';
import 'package:bitread_app/widget/searchbox.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';

class SearchSreen extends StatefulWidget {
  const SearchSreen({super.key});

  @override
  State<SearchSreen> createState() => _SearchSreenState();
}

List<String> searchResults = [];

Future<void> handleRefresh() async {
  return await Future.delayed(const Duration(milliseconds: 200));
}

class _SearchSreenState extends State<SearchSreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LiquidPullToRefresh(
          color: const Color(0xffFE0002),
          backgroundColor: Colors.white,
          onRefresh: handleRefresh,
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
                      showModalBottomSheet(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(25),
                          ),
                        ),
                        context: context,
                        isScrollControlled: true,
                        builder: (context) {
                          return FractionallySizedBox(
                            heightFactor: 0.76,
                            child: SearchResultScreen(searchQuery: query),
                          );
                        },
                      );
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
                        style: TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 14),
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
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Buku Terbaru',
                        style: TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 14),
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
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
