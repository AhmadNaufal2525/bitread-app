import 'package:bitread_app/widget/news_card.dart';
import 'package:flutter/material.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: ListView(
        children: const [
          NewsCard(title: 'Breaking News', description: 'This is sample description', imageUrl: 'assets/slider1.jpg'),
          SizedBox(height: 30,),
          NewsCard(title: 'Breaking News', description: 'This is sample description', imageUrl: 'assets/slider1.jpg'),
          SizedBox(height: 30,),
          NewsCard(title: 'Breaking News', description: 'This is sample description', imageUrl: 'assets/slider1.jpg'),
          SizedBox(height: 30,),
          NewsCard(title: 'Breaking News', description: 'This is sample description', imageUrl: 'assets/slider1.jpg'),
          SizedBox(height: 30,),
          NewsCard(title: 'Breaking News', description: 'This is sample description', imageUrl: 'assets/slider1.jpg'),
          SizedBox(height: 100,),
        ],
      ),),
    );
  }
}