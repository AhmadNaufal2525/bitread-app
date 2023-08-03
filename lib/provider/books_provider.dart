import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BooksProvider extends ChangeNotifier {
  Stream<List<Map<String, dynamic>>> fetchBooks() {
    return FirebaseFirestore.instance.collection('Books').snapshots().map(
      (QuerySnapshot snapshot) {
        return snapshot.docs.map(
          (DocumentSnapshot doc) {
            return {
              'id': doc.id,
              'title': doc['title'],
              'imageUrl': doc['imageUrl'],
              'ebook': doc['ebook'],
              'author': doc['author'],
              'rating': doc['rating'],
              'description': doc['description'],
              'url_book': doc['url_book']
            };
          },
        ).toList();
      },
    );
  }

  Stream<List<Map<String, dynamic>>> searchBooks(String searchQuery) {
    return FirebaseFirestore.instance.collection('Books').snapshots().map(
      (QuerySnapshot snapshot) {
        return snapshot.docs
            .where((doc) => doc['title']
                .toString()
                .toLowerCase()
                .contains(searchQuery.toLowerCase()))
            .map(
          (DocumentSnapshot doc) {
            return {
              'id': doc.id,
              'title': doc['title'],
              'imageUrl': doc['imageUrl'],
              'ebook': doc['ebook'],
              'author': doc['author'],
              'rating': doc['rating'],
              'description': doc['description'],
              'url_book': doc['url_book']
            };
          },
        ).toList();
      },
    );
  }
}
