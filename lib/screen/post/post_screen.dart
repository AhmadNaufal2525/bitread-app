import 'package:bitread_app/screen/post/add_post_screen.dart';
import 'package:bitread_app/screen/post/post_detail_screen.dart';
import 'package:bitread_app/widget/post_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

Future<void> handleRefresh() async {
  return await Future.delayed(const Duration(milliseconds: 200));
}

class _PostScreenState extends State<PostScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 100,
        elevation: 1,
        title: Column(
          children: [
            const Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Blog Harian',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                DateFormat("dd MMM, yyyy").format(DateTime.now()),
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        color: const Color(0xffFE0002),
        backgroundColor: Colors.white,
        onRefresh: handleRefresh,
        child: ListView(
          children: [
            const SizedBox(height: 16),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.76,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Post Blog')
                    .orderBy('timestamp', descending: false)
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
                      child: Text(
                          'Belum ada postingan blog, Jadilah yang pertama!'),
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
                        child: PostCard(
                          title: post['judul'],
                          description: post['isiBlog'],
                          imageUrl: post['imageURL'],
                          author: post['author'],
                          authorImage: post['authorImage'],
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddPostScreen(),
            ),
          );
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: const Color(0xffFE0002),
        child: const Icon(Icons.post_add_outlined),
      ),
    );
  }
}
