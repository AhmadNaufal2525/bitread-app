import 'package:bitread_app/widget/news_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

final List<Map<String, dynamic>> ListNews = [
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
    'imageUrl': 'assets/slider1.jpg',
  },
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
    'imageUrl': 'assets/slider1.jpg',
  },
   {
    'title': 'Be Modest, Be Social, Earn The Best',
    'description': 'This sample of description',
    'author': 'Jenie Morgana',
    'imageUrl': 'assets/slider1.jpg',
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
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                'Today Discover',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                DateFormat("dd MMM, yyyy").format(DateTime.now()),
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 620,
              child: ListView.separated(
              separatorBuilder: (context, index) => const SizedBox(height: 20),
              itemCount: ListNews.length,
              itemBuilder: (BuildContext context, int index) {
                final news = ListNews[index];
                return NewsCard(
                    title: news['title'],
                    description: news['description'],
                    imageUrl: news['imageUrl'],
                    author: news['author']);
              },
            ),
            ),
            
          ],
        ),
      ),
    );
  }
}
