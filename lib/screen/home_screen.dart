import 'package:bitread_app/widget/carousel.dart';
import 'package:bitread_app/widget/popular_book.dart';
import 'package:bitread_app/widget/recommended_book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> handleRefresh() async {
    return await Future.delayed(const Duration(milliseconds: 200));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        return Scaffold(
          body: SafeArea(
            child: LiquidPullToRefresh(
              color: const Color(0xffFE0002),
              backgroundColor: Colors.white,
              onRefresh: handleRefresh,
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
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              children: [
                                Column(
                                  children: [
                                    StreamBuilder<
                                        DocumentSnapshot<Map<String, dynamic>>>(
                                      stream: FirebaseFirestore.instance
                                          .collection('User')
                                          .doc(FirebaseAuth
                                              .instance.currentUser?.uid)
                                          .snapshots(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<
                                                  DocumentSnapshot<
                                                      Map<String, dynamic>>>
                                              snapshot) {
                                        if (snapshot.hasData &&
                                            snapshot.data!.exists) {
                                          var data = snapshot.data!.data();
                                          String? username = data?['username'];
                                          if (username != null &&
                                              username.isNotEmpty) {
                                            return Center(
                                              child: Text(
                                                "Hallo ${username.length > 12 ? '${username.substring(0, 12)},' : '$username,'}",
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            );
                                          }
                                        }
                                        return const Text(
                                          "Hallo User",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 18.8,
                                          ),
                                        );
                                      },
                                    ),
                                  ],
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
                                            backgroundColor: Colors.grey,
                                            radius: 35,
                                            backgroundImage:
                                                NetworkImage(image),
                                          );
                                        } else {
                                          String? googleProfileImage =
                                              FirebaseAuth.instance.currentUser
                                                  ?.photoURL;
                                          if (googleProfileImage != null) {
                                            return CircleAvatar(
                                              backgroundColor: Colors.grey,
                                              radius: 35,
                                              backgroundImage: NetworkImage(
                                                googleProfileImage,
                                              ),
                                            );
                                          }
                                        }
                                      }
                                      return const CircleAvatar(
                                        radius: 35,
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
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text('Mau baca apa hari ini?'),
                          ),
                          const SizedBox(
                            height: 26,
                          ),
                          const Carousel(),
                          const SizedBox(
                            height: 26,
                          ),
                          const RecomBook(),
                          const SizedBox(
                            height: 20,
                          ),
                          const PopularBook()
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
