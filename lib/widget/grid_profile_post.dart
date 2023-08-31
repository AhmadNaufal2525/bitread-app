import 'package:bitread_app/screen/post/post_detail_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GridProfilePost extends StatefulWidget {
  const GridProfilePost({super.key});

  @override
  State<GridProfilePost> createState() => _GridProfilePostState();
}

class _GridProfilePostState extends State<GridProfilePost> {
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    String currentUserId = auth.currentUser?.uid ?? "";
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Post Blog')
          .where('userId', isEqualTo: currentUserId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }
        
        final docs = snapshot.data!.docs;
        if (docs.isEmpty) {
          return const Center(
            child: Text('Kamu belum memposting blog apapun'),
          );
        }
        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.9,
          ),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final post = docs[index];
            String imageUrl = docs[index].get('imageURL');
            return InkWell(
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PostDetailScreen(
                      title: post['judul'],
                      description: post['isiBlog'],
                      imageUrl: post['imageURL'],
                      author: post['author'],
                      authorUserId: post['userId'],
                      id: post['id'],
                      likes: List<String>.from(
                        post['Likes'] ?? [],
                      ),
                      authorImage: post['authorImage'],
                      timestamp: post['timestamp'],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
