import 'package:bitread_app/screen/opening_screen.dart';
import 'package:flutter/material.dart';
import 'package:bitread_app/widget/profile_header_widget.dart';
import 'package:bitread_app/widget/profile_liked_post.dart';
import 'package:bitread_app/widget/profile_post.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key});

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  int postCount = 0;
  GoogleSignIn googleSignIn = GoogleSignIn();
  Future<void> setLoggedIn(bool isLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', isLoggedIn);
  }

  Future<void> logout() async {
    await setLoggedIn(false);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const OpeningScreen(),
      ),
      (route) => false,
    );
    await auth.signOut();
    await googleSignIn.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              child: Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(
                    Icons.logout,
                    color: Color(0xffFE0002),
                  ),
                  onPressed: logout,
                ),
              ),
            ),
            Expanded(
              child: DefaultTabController(
                length: 2,
                child: NestedScrollView(
                  headerSliverBuilder: (context, _) {
                    return [
                      SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            const ProfileHeader(),
                          ],
                        ),
                      ),
                    ];
                  },
                  body: Column(
                    children: [
                      Material(
                        color: Colors.white,
                        child: TabBar(
                          labelColor: Colors.black,
                          unselectedLabelColor: Colors.grey[400],
                          indicatorWeight: 1,
                          indicatorColor: const Color(0xffFE0002),
                          tabs: const [
                            Tab(
                              text: 'Post',
                            ),
                            Tab(
                              text: 'Liked Post',
                            ),
                          ],
                        ),
                      ),
                      const Expanded(
                        child: TabBarView(
                          children: [ProfilePost(), ProfileLikedPost()],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
