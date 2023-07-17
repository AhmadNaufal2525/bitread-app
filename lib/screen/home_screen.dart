import 'package:bitread_app/screen/book_detail_screen.dart';
import 'package:bitread_app/screen/more_popular_book.dart';
import 'package:bitread_app/screen/more_recom_book.dart';
import 'package:bitread_app/widget/card_book.dart';
import 'package:bitread_app/widget/carousel.dart';
import 'package:bitread_app/widget/popular_book.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    final user = FirebaseAuth.instance.currentUser;
    final username = user?.displayName ?? "User";
    return Scaffold(
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
                          Text(
                            "Hallo $username,",
                            style: const TextStyle(
                                fontWeight: FontWeight.w800, fontSize: 24),
                          ),
                          const Spacer(),
                          CircleAvatar(
                            backgroundColor: Colors.grey,
                            radius: 30,
                            child: Image.asset('assets/profil.png'),
                          )
                        ],
                      ),
                    ),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 14),
                          child: Text('Mau baca apa hari ini?'),
                        )
                      ],
                    ),
                    const Column(
                      children: [
                        Carousel(),
                        SizedBox(
                          height: 26,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Rekomendasi Buku',
                          style: TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 14),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const RecommendedBookScreen(),
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
                    const SizedBox(
                      height: 20,
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
                    SizedBox(
                      height: 320,
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
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
                                    rating: book['rating'].toString(),
                                    imageUrl: book['imageUrl'],
                                  ),
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
                      ),
                    ),
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
