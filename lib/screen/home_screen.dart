import 'package:bitread_app/screen/book_detail_screen.dart';
import 'package:bitread_app/screen/more_popular_book.dart';
import 'package:bitread_app/screen/more_recom_book.dart';
import 'package:bitread_app/widget/card_book.dart';
import 'package:bitread_app/widget/carousel.dart';
import 'package:bitread_app/widget/popular_book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

Future<List<Map<String, dynamic>>> fetchBooks() async {
  final collectionRef = FirebaseFirestore.instance.collection('Books');
  final querySnapshot = await collectionRef.get();
  return querySnapshot.docs
      .map((doc) => {
            'id': doc.id,
            'title': doc['title'],
            'imageUrl': doc['imageUrl'],
            'ebook': doc['ebook'],
            'author': doc['author'],
            'rating': doc['rating'],
            'description': doc['description'],
          })
      .toList();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        final user = snapshot.data;
        final username = user?.displayName ?? "User";
        return Scaffold(
          body: SafeArea(
            child: ListView(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            children: [
                              Text(
                                "Hallo ${username.length > 12 ? '${username.substring(0, 12)},' : '$username,'}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w800, fontSize: 20),
                              ),
                              const Spacer(),
                              SizedBox(
                                child: StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection('User')
                                      .where('id',
                                          isEqualTo: FirebaseAuth
                                              .instance.currentUser?.uid)
                                      .snapshots(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.hasData &&
                                        snapshot.data!.docs.isNotEmpty) {
                                      var data = snapshot.data!.docs[0];
                                      String image = data['image'];
                                      if (image.isNotEmpty) {
                                        return CircleAvatar(
                                          radius: 30,
                                          backgroundColor: Colors.grey,
                                          backgroundImage: NetworkImage(image),
                                        );
                                      } else {
                                        String? googleProfileImage =
                                            FirebaseAuth
                                                .instance.currentUser?.photoURL;
                                        if (googleProfileImage != null) {
                                          return CircleAvatar(
                                            radius: 30,
                                            backgroundColor: Colors.grey,
                                            backgroundImage: NetworkImage(
                                                googleProfileImage),
                                          );
                                        }
                                      }
                                    }
                                    return const CircleAvatar(
                                      radius: 30,
                                      backgroundColor: Colors.grey,
                                      backgroundImage:
                                          AssetImage('assets/user.png'),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 14),
                              child: Text('Mau baca apa hari ini?'),
                            )
                          ],
                        ),
                        const Column(
                          children: [
                            Carousel(),
                            SizedBox(
                              height: 26,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Rekomendasi Buku',
                              style: TextStyle(
                                  fontWeight: FontWeight.w800, fontSize: 14),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const RecommendedBookScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Lihat Semua',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        FutureBuilder<List<Map<String, dynamic>>>(
                          future: fetchBooks(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            if (snapshot.hasError) {
                              return Center(
                                child: Text('Error: ${snapshot.error}'),
                              );
                            }

                            final List<Map<String, dynamic>>? books =
                                snapshot.data;

                            return SizedBox(
                              height: 260,
                              child: ListView.separated(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(width: 20),
                                itemCount: books!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final book = books[index];
                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              BookDetailScreen(
                                            id: book['id'],
                                            title: book['title'],
                                            author: book['author'],
                                            rating: book['rating'].toString(),
                                            imageUrl: book['imageUrl'],
                                            desc: book['description'],
                                          ),
                                        ),
                                      );
                                    },
                                    child: BookCard(
                                      title: book['title'],
                                      author: book['author'],
                                      rating: book['rating'],
                                      imageUrl: book['imageUrl'],
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Buku Terpopuler',
                              style: TextStyle(
                                  fontWeight: FontWeight.w800, fontSize: 14),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const PopularBookScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Lihat Semua',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        FutureBuilder<List<Map<String, dynamic>>>(
                          future: fetchBooks(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            if (snapshot.hasError) {
                              return Center(
                                child: Text('Error: ${snapshot.error}'),
                              );
                            }

                            final List<Map<String, dynamic>>? books =
                                snapshot.data;
                            return SizedBox(
                              height: 320,
                              child: GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 16.0,
                                ),
                                itemCount: books!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final book = books[index];
                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              BookDetailScreen(
                                            title: book['title'],
                                            author: book['author'],
                                            rating: book['rating'].toString(),
                                            imageUrl: book['imageUrl'],
                                            desc: book['description'],
                                            id: book['id'],
                                          ),
                                        ),
                                      );
                                    },
                                    child: PopularBook(
                                      title: book['title'],
                                      author: book['author'],
                                      rating: book['rating'],
                                      imageUrl: book['imageUrl'],
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
