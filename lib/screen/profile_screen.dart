import 'package:bitread_app/screen/login_screen.dart';
import 'package:bitread_app/widget/custom_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key});

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();
  Future<void> logout() async {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const LoginScreen(),
      ),
      (route) => false,
    );
    await auth.signOut();
    await googleSignIn.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final username = user?.displayName ?? "User";
    final email = user?.email;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.center,
              child: Text(
                'Profile',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 22),
              ),
            ),
            SizedBox(
              height: 220,
              child: Center(
                child: SizedBox(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('User')
                        .where('id',
                            isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        var data = snapshot.data!.docs[0];
                        String image = data['image'];
                        if (image.isNotEmpty) {
                          return CircleAvatar(
                            radius: 80,
                            backgroundImage: NetworkImage(image),
                          );
                        }
                      }
                      return const CircleAvatar(
                        radius: 80,
                        backgroundColor: Colors.grey,
                        backgroundImage: AssetImage('assets/user.png'),
                      );
                    },
                  ),
                ),
              ),
            ),
            Text(
              username,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '$email',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      'Posts',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '230',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 28),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 36),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Social Media',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Row(
                      children: [
                        Icon(
                          Icons.facebook,
                          size: 24,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'facebook.com/johndoe',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Row(
                      children: [
                        Icon(
                          Icons.mail,
                          size: 24,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'twitter.com/johndoe',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 60),
                    Center(
                      child: CustomButton(
                        icon: const Icon(Icons.logout_rounded),
                        text: ('Logout'),
                        onPressed: () {
                          logout();
                        },
                        color: const Color(0xffFE0002),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
