import 'package:bitread_app/screen/book_detail_screen.dart';
import 'package:bitread_app/widget/popular_book.dart';
import 'package:flutter/material.dart';

class RecommendedBookScreen extends StatefulWidget {
  const RecommendedBookScreen({super.key});

  @override
  State<RecommendedBookScreen> createState() => _RecommendedBookScreenState();
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

class _RecommendedBookScreenState extends State<RecommendedBookScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.arrow_back),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: SizedBox(
                    height: 340,
                    child: GridView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
