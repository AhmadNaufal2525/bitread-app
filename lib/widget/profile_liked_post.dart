import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileLikedPost extends StatefulWidget {
  const ProfileLikedPost({super.key});

  @override
  ProfileLikedPostState createState() => ProfileLikedPostState();
}

class ProfileLikedPostState extends State<ProfileLikedPost> {
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
        final posts = snapshot.data!.docs;
        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.9,
          ),
          itemCount: posts.length,
          itemBuilder: (context, index) {
            String imageUrl = posts[index].get('imageURL');
            return Image.network(
              imageUrl,
              fit: BoxFit.fitWidth,
            );
          },
        );
      },
    );
  }
}
