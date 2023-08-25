import 'package:bitread_app/screen/post_detail_screen.dart';
import 'package:bitread_app/widget/post_card.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ListProfilePost extends StatefulWidget {
  const ListProfilePost({super.key});

  @override
  ListProfilePostState createState() => ListProfilePostState();
}

class ListProfilePostState extends State<ListProfilePost> {
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
        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final post = docs[index];
            return ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: InkWell(
                child: PostCard(
                  title: post['judul'],
                  description: post['isiBlog'],
                  imageUrl: post['imageURL'],
                  author: post['author'],
                  authorImage: post['authorImage'],
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
              ),
            );
          },
        );
      },
    );
  }
}
