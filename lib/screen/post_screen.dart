import 'package:bitread_app/screen/add_post_screen.dart';
import 'package:bitread_app/screen/post_detail_screen.dart';
import 'package:bitread_app/widget/post_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        toolbarHeight: 80,
        title: const Text(
          'Blog Harian',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                DateFormat("dd MMM, yyyy").format(DateTime.now()),
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ),
        actions: [
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
            color: const Color(0xffFE0002),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          children: [
            const SizedBox(height: 16),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.76,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Post Blog')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }
                  final docs = snapshot.data!.docs;
                  if (docs.isEmpty) {
                    return const Center(
                      child: Text('Post tidak ditemukan'),
                    );
                  }
                  return ListView.separated(
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 20),
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final post = docs[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PostDetailScreen(
                                title: post['judul'],
                                description: post['isiBlog'],
                                imageUrl: post['imageURL'],
                                author: post['author'],
                              ),
                            ),
                          );
                        },
                        child: PostCard(
                          title: post['judul'],
                          description: post['isiBlog'],
                          imageUrl: post['imageURL'],
                          author: post['author'],
                        ),
                      );
                    },
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
