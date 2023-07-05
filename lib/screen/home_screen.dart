import 'package:bitread_app/screen/book_screen.dart';
import 'package:bitread_app/widget/card_book.dart';
import 'package:bitread_app/widget/carousel.dart';
import 'package:bitread_app/widget/popular_book.dart';
import 'package:bitread_app/widget/searchbox.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
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

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF2F5F9),
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          const Text(
                            "Hallo Naufal,",
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 24),
                          ),
                          const Spacer(),
                          CircleAvatar(
                            radius: 30,
                            child: Image.asset('assets/profil.png'),
                          )
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        const SizedBox(
                          height: 26,
                        ),
                        const SearchBox(),
                        Carousel(),
                        const SizedBox(
                          height: 26,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Rekomendasi Untuk Kamu',
                          style: TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 14),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Lihat Semua',
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
                                    builder: (context) => const BookScreen()),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Buku Terpopuler',
                          style: TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 14),
                        ),
                        TextButton(
                          onPressed: () {},
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
                    SizedBox(
                      height: 600,
                      child: ListView.separated(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 36),
                        itemCount: books.length,
                        itemBuilder: (BuildContext context, int index) {
                          final book = books[index];
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const BookScreen()),
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
                      ),
                    ),
                    SizedBox(height: 100,)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
