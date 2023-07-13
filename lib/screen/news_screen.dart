import 'package:bitread_app/screen/add_post_screen.dart';
import 'package:bitread_app/screen/news_detail_screen.dart';
import 'package:bitread_app/widget/news_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

final List<Map<String, dynamic>> listNews = [
  {
    'title': 'Be Modest, Be Social, Earn The Best',
    'description': 'This sample of description',
    'author': 'Jenie Morgana',
    'imageUrl': 'assets/slider1.jpg',
  },
  {
    'title': 'Be Modest, Be Social, Earn The Best',
    'description': 'This sample of description',
    'author': 'Jenie Morgana',
    'imageUrl': 'assets/slider2.jpg',
  },
  {
    'title': 'Be Modest, Be Social, Earn The Best',
    'description': 'This sample of description',
    'author': 'Jenie Morgana',
    'imageUrl': 'assets/slider3.jpg',
  },
];

class _NewsScreenState extends State<NewsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            const SizedBox(height: 16.0),
            Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Blog Harian',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddPostScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.post_add_outlined),
                    ),
                  ],
                )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                DateFormat("dd MMM, yyyy").format(DateTime.now()),
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 620,
              child: ListView.separated(
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 20),
                itemCount: listNews.length,
                itemBuilder: (BuildContext context, int index) {
                  final news = listNews[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewsDetailScreen(
                            title: news['title'],
                            description: news['description'],
                            imageUrl: news['imageUrl'],
                            author: news['author'],
                          ),
                        ),
                      );
                    },
                    child: NewsCard(
                      title: news['title'],
                      description: news['description'],
                      imageUrl: news['imageUrl'],
                      author: news['author'],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
