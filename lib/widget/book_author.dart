import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookAuthor extends StatefulWidget {
  const BookAuthor({super.key});

  @override
  State<BookAuthor> createState() => _BookAuthorState();
}

class _BookAuthorState extends State<BookAuthor> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('User')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .snapshots(),
      builder: (BuildContext context,
          AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> userSnapshot) {
        if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
          return const SizedBox();
        } else {
          var userData = userSnapshot.data!.data();
          String? currentUsername = userData?['username'];

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Books')
                .where('author', isEqualTo: currentUsername)
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot> bookSnapshot) {
              if (bookSnapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator(); 
              } else if (bookSnapshot.hasError) {
                return const Text('Error loading books'); // Handle errors
              } else if (bookSnapshot.hasData &&
                  bookSnapshot.data!.docs.isNotEmpty) {
                var bookDocs = bookSnapshot.data!.docs;
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 10.0,
                  ),
                  itemCount: bookDocs.length,
                  itemBuilder: (context, index) {
                    var bookData =
                        bookDocs[index].data() as Map<String, dynamic>;
                    String imageUrl = bookData['imageUrl'];
                    return Image.network(imageUrl);
                  },
                );
              } else {
                return const Center(
                  child: Text("Buku terbitanmu tidak ditemukan"),
                );
              }
            },
          );
        }
      },
    );
  }
}
