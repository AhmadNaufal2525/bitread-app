import 'package:bitread_app/screen/edit_post_screen.dart';
import 'package:bitread_app/widget/like_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

class PostDetailScreen extends StatefulWidget {
  final String title;
  final String description;
  final String imageUrl;
  final String author;
  final String authorUserId;
  final String id;
  final List<String> likes;

  const PostDetailScreen({
    super.key,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.author,
    required this.authorUserId,
    required this.id,
    required this.likes,
  });

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final currentUser = FirebaseAuth.instance.currentUser;
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser!.uid);
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });
    DocumentReference postRef =
        FirebaseFirestore.instance.collection('Post Blog').doc(widget.id);
    if (isLiked) {
      postRef.update(
        {
          'Likes': FieldValue.arrayUnion(
            [currentUser!.uid],
          ),
        },
      );
    } else {
      postRef.update(
        {
          'Likes': FieldValue.arrayRemove(
            [currentUser!.uid],
          ),
        },
      );
    }
  }

  void deletePost(BuildContext context) async {
    try {
      final storageRef = FirebaseStorage.instance.ref();
      await storageRef.child('post_images').child('${widget.id}.jpg').delete();
      final postCollection = FirebaseFirestore.instance.collection('Post Blog');
      await postCollection.doc(widget.id).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Blog Berhasil Dihapus! ',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      errorAlert();
    }
  }

  void errorAlert() {
    QuickAlert.show(
      context: context,
      title: 'Gagal',
      text: 'Gagal menghapus blog, coba lagi nanti',
      type: QuickAlertType.error,
      confirmBtnText: 'Ok',
      onConfirmBtnTap: () {
        Navigator.of(context).pop();
      },
    );
  }

  void confirmDeleteAlert() {
    QuickAlert.show(
      context: context,
      title: 'Hapus Blog',
      text: 'Apakah anda yakin untuk menghapus blog ini?',
      type: QuickAlertType.confirm,
      confirmBtnText: 'Ok',
      cancelBtnText: 'Cancel',
      onConfirmBtnTap: () {
       deletePost(context);
       Navigator.pop(context);
      },
      onCancelBtnTap: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isCurrentUserAuthor = currentUser?.uid == widget.authorUserId;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                color: Colors.white,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              actions: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 14,),
                      LikeButton(
                        isLiked: isLiked,
                        onTap: toggleLike,
                      ),
                      StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Post Blog')
                      .snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      int totalLikesCount = 0;
                      
                      for (QueryDocumentSnapshot doc in snapshot.data!.docs) {
                        Map<String, dynamic> postData = doc.data() as Map<String, dynamic>;
                        List<dynamic> likes = postData['Likes'] ?? [];
                        totalLikesCount += likes.length;
                      }
                      
                      return Text('$totalLikesCount');
                    } else if (snapshot.hasError) {
                      return const Text('Error loading likes count');
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                )
                
                    ],
                  ),
                ),
                if (isCurrentUserAuthor)
                  PopupMenuButton<String>(
                    icon: const Icon(
                      Icons.more_vert_rounded,
                      color: Colors.white,
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
                       confirmDeleteAlert();
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
              expandedHeight: MediaQuery.of(context).size.height * 0.45,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.network(
                        widget.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Oleh ${widget.author}',
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                      ),
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.description,
                          textAlign: TextAlign.justify,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
