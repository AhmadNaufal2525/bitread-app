import 'package:bitread_app/screen/edit_profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileHeader extends StatefulWidget {
  const ProfileHeader({super.key});

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 55),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('User')
                        .where('id',
                            isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                        var data = snapshot.data!.docs[0];
                        String? image = data['image'] ??
                            FirebaseAuth.instance.currentUser?.photoURL;
                        if (image != null && image.isNotEmpty) {
                          return CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.grey,
                            backgroundImage: NetworkImage(image),
                          );
                        }
                      }
                      return const CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey,
                        backgroundImage: AssetImage('assets/user.png'),
                      );
                    },
                  ),
                  InkWell(
                    onTap: () async {
                      final user = FirebaseAuth.instance.currentUser;
                      if (user != null) {
                        try {
                          final userDoc = await FirebaseFirestore.instance
                              .collection('User')
                              .doc(user.uid)
                              .get();
                          if (userDoc.exists) {
                            final userData = userDoc.data();
                            final username = userData?['username'] ?? '';
                            final email = userData?['email'] ?? '';
                            final image = userData?['image'] ?? '';
                            final instagram = userData?['instagram'] ?? '';
                            final twitter = userData?['twitter'] ?? '';
                            final facebook = userData?['facebook'] ?? '';

                            setState(
                              () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditProfile(
                                      username: username,
                                      email: email,
                                      image: image,
                                      id: user.uid,
                                      facebook: facebook,
                                      instagram: instagram,
                                      twitter: twitter,
                                    ),
                                  ),
                                );
                              },
                            );
                          } else {
                            setState(
                              () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('User data does not exist.'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              },
                            );
                          }
                        } catch (error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error loading user data: $error'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('User is not authenticated.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    child: const CircleAvatar(
                      radius: 16,
                      backgroundColor: Color(0xffFE0002),
                      child: Icon(Icons.edit, size: 15, color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('User')
                    .doc(FirebaseAuth.instance.currentUser?.uid)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.hasData && snapshot.data!.exists) {
                    var data = snapshot.data!.data();
                    String? username = data?['username'];
                    if (username != null && username.isNotEmpty) {
                      return Center(
                        child: Text(
                          username,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }
                  }
                  return const Center(
                    child: Text(
                      'User',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 26.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      GestureDetector(
                        child: Image.asset('assets/instagram.png',
                            height: 40, width: 40),
                        onTap: () async {
                          final userId = FirebaseAuth.instance.currentUser?.uid;

                          if (userId != null) {
                            final userDoc = await FirebaseFirestore.instance
                                .collection('User')
                                .doc(userId)
                                .get();

                            if (userDoc.exists) {
                              final userData = userDoc.data();
                              final instagramUrl = userData?['instagram'];

                              if (instagramUrl != null &&
                                  instagramUrl.isNotEmpty) {
                                final url = Uri.parse(instagramUrl);
                                await launchUrl(url);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    showCloseIcon: true,
                                    closeIconColor: Colors.white,
                                    content: Text(
                                        'Kamu belum menambahkan link Instagram mu!'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          }
                        },
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
                  Column(
                    children: [
                      GestureDetector(
                        child: Image.asset('assets/twitter.png',
                            height: 40, width: 40),
                        onTap: () async {
                          final userId = FirebaseAuth.instance.currentUser?.uid;

                          if (userId != null) {
                            final userDoc = await FirebaseFirestore.instance
                                .collection('User')
                                .doc(userId)
                                .get();

                            if (userDoc.exists) {
                              final userData = userDoc.data();
                              final twitterUrl = userData?['twitter'];

                              if (twitterUrl != null && twitterUrl.isNotEmpty) {
                                final url = Uri.parse(twitterUrl);
                                await launchUrl(url);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    showCloseIcon: true,
                                    closeIconColor: Colors.white,
                                    content: Text(
                                        'Kamu belum menambahkan link Twitter mu!'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          }
                        },
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
                  Column(
                    children: [
                      GestureDetector(
                        child: Image.asset('assets/facebook.png',
                            height: 40, width: 40),
                        onTap: () async {
                          final userId = FirebaseAuth.instance.currentUser?.uid;

                          if (userId != null) {
                            final userDoc = await FirebaseFirestore.instance
                                .collection('User')
                                .doc(userId)
                                .get();

                            if (userDoc.exists) {
                              final userData = userDoc.data();
                              final facebookUrl = userData?['facebook'];

                              if (facebookUrl != null &&
                                  facebookUrl.isNotEmpty) {
                                final url = Uri.parse(facebookUrl);
                                await launchUrl(url);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    showCloseIcon: true,
                                    closeIconColor: Colors.white,
                                    content: Text(
                                        'Kamu belum menambahkan link Facebook mu!'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          }
                        },
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
                ],
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
