import 'package:bitread_app/widget/bottom_navigation.dart';
import 'package:bitread_app/widget/news_card.dart';
import 'package:flutter/material.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  AddPostScreenState createState() => AddPostScreenState();
}

class AddPostScreenState extends State<AddPostScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _title;
  String? _description;
  String? _imageUrl;
  String? _author;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BottomNav(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
                const Text(
                  'Tambahkan Postingan Blog mu disini',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                  onSaved: (value) => _title = value,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Description'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                  onSaved: (value) => _description = value,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Image URL'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an image URL';
                    }
                    return null;
                  },
                  onSaved: (value) => _imageUrl = value,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Author'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an author';
                    }
                    return null;
                  },
                  onSaved: (value) => _author = value,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      // Create the new news card with the entered values
                      final newNewsCard = NewsCard(
                        title: _title!,
                        description: _description!,
                        imageUrl: _imageUrl!,
                        author: _author!,
                      );
                      print('New News Card:');
                      print('Title: ${newNewsCard.title}');
                      print('Description: ${newNewsCard.description}');
                      print('Image URL: ${newNewsCard.imageUrl}');
                      print('Author: ${newNewsCard.author}');
                    }
                  },
                  child: const Text('Add Post'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
