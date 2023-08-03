import 'package:bitread_app/screen/edit_post_screen.dart';
import 'package:bitread_app/widget/failed_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class PostDetailScreen extends StatefulWidget {
  final String title;
  final String description;
  final String imageUrl;
  final String author;
  final String authorUserId;
  final String id;

  const PostDetailScreen({
    super.key,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.author,
    required this.authorUserId,
    required this.id,
  });

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  void deletePost(BuildContext context) async {
    try {
      final storageRef = FirebaseStorage.instance.ref();
      await storageRef.child('post_images').child('${widget.id}.jpg').delete();
      final postCollection = FirebaseFirestore.instance.collection('Post Blog');
      await postCollection.doc(widget.id).delete();
      Navigator.pop(context);
    } catch (e) {
      const FailedDialog(
        message: 'Gagal menghapus blog, coba lagi nanti',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final isCurrentUserAuthor = currentUser?.uid == widget.authorUserId;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.white,
        centerTitle: true,
        shadowColor: Colors.transparent,
        title: const Text(
          'Blog',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          if (isCurrentUserAuthor)
            PopupMenuButton<String>(
              icon: const Icon(
                Icons.more_vert_rounded,
                color: Colors.black,
              ),
              onSelected: (String value) async {
                if (value == 'edit') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditPost(
                        description: widget.description,
                        id: widget.id,
                        image: widget.imageUrl,
                        title: widget.title,
                      ),
                    ),
                  );
                } else if (value == 'delete') {
                  final confirmed = await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Hapus Blog'),
                      content: const Text(
                          'Apakah Anda yakin ingin menghapus blog ini?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text(
                            'Batal',
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text(
                            'Hapus',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                  if (confirmed) {
                    deletePost(context);
                  }
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem<String>(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(
                          Icons.edit_rounded,
                          color: Colors.blue,
                        ),
                        SizedBox(width: 8),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete_rounded,
                          color: Colors.red,
                        ),
                        SizedBox(width: 8),
                        Text('Delete'),
                      ],
                    ),
                  ),
                ];
              },
            ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxWidth = constraints.maxWidth;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Image.network(
                      widget.imageUrl,
                      fit: BoxFit.cover,
                      width: maxWidth,
                      height: maxWidth * 0.6,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Oleh ${widget.author}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          widget.description,
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
