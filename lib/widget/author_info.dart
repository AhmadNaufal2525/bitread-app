import 'package:bitread_app/screen/author_booklist_screen.dart';
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
    return Column(
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
                    " ${author.length > 12 ? author.substring(0, 12) : author}",
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
                        await launchUrl(url);
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
                        await launchUrl(url);
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
                        await launchUrl(url);
                      }
                    }
                  },
                ),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 26,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 80),
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Books')
                    .where('author', isEqualTo: author)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> bookSnapshot) {
                  if (bookSnapshot.hasData &&
                      bookSnapshot.data!.docs.isNotEmpty) {
                    var bookData = bookSnapshot.data!.docs[0].data()
                        as Map<String, dynamic>;
                    String imageUrl = bookData['imageUrl'];
                    int imageCount = bookSnapshot.data!.docs.length;

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookListByAuthor(
                              author: author,
                            ),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              CircleAvatar(
                                radius: 26,
                                backgroundColor: Colors.grey,
                                backgroundImage: NetworkImage(imageUrl),
                              ),
                              const SizedBox(width: 20),
                              CircleAvatar(
                                backgroundColor: Colors.red.withAlpha(160),
                                radius: 12,
                                child: Text(
                                  '+${imageCount.toString()}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          const Text('Lihat Buku Penulis')
                        ],
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
