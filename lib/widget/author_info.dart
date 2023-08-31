import 'package:bitread_app/screen/book/book_detail_screen.dart';
import 'package:bitread_app/widget/grid_card_book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthorInfo extends StatelessWidget {
  final String authorImage;
  final String author;
  final String authorUserId;
  const AuthorInfo(
      {super.key,
      required this.authorImage,
      required this.author,
      required this.authorUserId});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(authorImage),
                radius: 40,
                backgroundColor: Colors.grey,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Text(
                      " ${author.length > 14 ? author.substring(0, 12) : author}",
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const Text(
                      'Follow Saya di Media Sosial',
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  GestureDetector(
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/instagram.png',
                          height: 40,
                          width: 40,
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        const Text(
                          'Instagram',
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    onTap: () async {
                      final userId = authorUserId;

                      final userDoc = await FirebaseFirestore.instance
                          .collection('User')
                          .doc(userId)
                          .get();

                      if (userDoc.exists) {
                        final userData = userDoc.data();
                        final instagramUrl = userData?['instagram'];

                        if (instagramUrl != null && instagramUrl.isNotEmpty) {
                          final url = Uri.parse(instagramUrl);
                          await launchUrl(url,
                                    mode: LaunchMode.externalApplication);
                        }
                      }
                    },
                  ),
                ],
              ),
              Column(
                children: [
                  GestureDetector(
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/twitter.png',
                          height: 40,
                          width: 40,
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        const Text(
                          'Twitter',
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    onTap: () async {
                      final userId = authorUserId;

                      final userDoc = await FirebaseFirestore.instance
                          .collection('User')
                          .doc(userId)
                          .get();

                      if (userDoc.exists) {
                        final userData = userDoc.data();
                        final twitterUrl = userData?['twitter'];

                        if (twitterUrl != null && twitterUrl.isNotEmpty) {
                          final url = Uri.parse(
                            twitterUrl,
                          );
                          await launchUrl(url,
                                    mode: LaunchMode.externalApplication);
                        }
                      }
                    },
                  ),
                ],
              ),
              Column(
                children: [
                  GestureDetector(
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/facebook.png',
                          height: 40,
                          width: 40,
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        const Text(
                          'Facebook',
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    onTap: () async {
                      final userId = authorUserId;

                      final userDoc = await FirebaseFirestore.instance
                          .collection('User')
                          .doc(userId)
                          .get();

                      if (userDoc.exists) {
                        final userData = userDoc.data();
                        final facebookUrl = userData?['facebook'];

                        if (facebookUrl != null && facebookUrl.isNotEmpty) {
                          final url = Uri.parse(facebookUrl);
                          await launchUrl(url,
                                    mode: LaunchMode.externalApplication);
                        }
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 18,
          ),
          const Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Buku Penulis',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 18,
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Books')
                .where('author', isEqualTo: author)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                    child: Text('Penulis Belum Menerbitkan Buku'));
              }
              List<Map<String, dynamic>> books = snapshot.data!.docs
                  .map((doc) => doc.data() as Map<String, dynamic>)
                  .toList();

              return SizedBox(
                height: 350,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.0,
                  ),
                  itemCount: books.length,
                  itemBuilder: (BuildContext context, int index) {
                    QueryDocumentSnapshot doc = snapshot.data!.docs[index];
                    String bookTitle = doc['title'];
                    String bookId = doc.id;
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
                            ),
                          ),
                        );
                      },
                      child: GridCardBook(
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
        ],
      ),
    );
  }
}
