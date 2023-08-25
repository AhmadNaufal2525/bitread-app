import 'package:bitread_app/screen/book_detail_screen.dart';
import 'package:bitread_app/widget/card_book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BookListByAuthor extends StatefulWidget {
  final String author;
  const BookListByAuthor({super.key, required this.author});

  @override
  State<BookListByAuthor> createState() => _BookListByAuthorState();
}

class _BookListByAuthorState extends State<BookListByAuthor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          widget.author,
          style: const TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        shadowColor: Colors.transparent,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Books')
            .where('author', isEqualTo: widget.author)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No books found for this author.'));
          }

          // List of books data
          List<Map<String, dynamic>> books = snapshot.data!.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .toList();

          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: ListView.builder(
              itemCount: books.length,
              itemBuilder: (BuildContext context, int index) {
                QueryDocumentSnapshot doc = snapshot.data!.docs[index];
                String bookTitle = doc['title'];
                String bookId = doc.id; // Get the document ID
                String bookAuthor = doc['author'];
                double bookRating = doc['rating'] ?? 0.0;
                String bookDesc = doc['description'];
                String bookUrl = doc['url_book'];
                String? bookImageUrl = doc['imageUrl'];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookDetailScreen(
                          id: bookId,
                          title: bookTitle,
                          author: bookAuthor,
                          rating: bookRating,
                          imageUrl: bookImageUrl ?? '',
                          desc: bookDesc,
                          url: bookUrl,
                          // Pass other necessary data
                        ),
                      ),
                    );
                  },
                  child: BookCard(
                    title: bookTitle,
                    author: bookAuthor,
                    rating: bookRating,
                    imageUrl: bookImageUrl,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
