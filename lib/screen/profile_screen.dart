import 'package:bitread_app/screen/opening_screen.dart';
import 'package:bitread_app/widget/book_author.dart';
import 'package:bitread_app/widget/grid_profile_post.dart';
import 'package:flutter/material.dart';
import 'package:bitread_app/widget/profile_header_widget.dart';
import 'package:bitread_app/widget/list_profile_post.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key});

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();
  Future<void> setLoggedIn(bool isLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', isLoggedIn);
  }

  Future<void> logout() async {
    await setLoggedIn(false);
    setState(
      () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const OpeningScreen(),
          ),
          (route) => false,
        );
      },
    );
    await auth.signOut();
    await googleSignIn.signOut();
  }

  Future<void> handleRefresh() async {
    return await Future.delayed(const Duration(milliseconds: 200));
  }

  void confirmLogoutAlert() {
    QuickAlert.show(
      context: context,
      title: 'Logout',
      text: 'Apakah anda yakin untuk logout?',
      type: QuickAlertType.confirm,
      confirmBtnText: 'Ok',
      cancelBtnText: 'Cancel',
      onConfirmBtnTap: () {
        logout();
      },
      onCancelBtnTap: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Color(0xffFE0002),
            ),
            onPressed: confirmLogoutAlert,
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: DefaultTabController(
              length: 3,
              child: NestedScrollView(
                headerSliverBuilder: (context, _) {
                  return [
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          const ProfileHeader(),
                          const SizedBox(height: 20),
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
                        indicatorWeight: 3,
                        indicatorColor: const Color(0xffFE0002),
                        tabs: const [
                          Tab(
                            icon: Icon(Icons.view_list_rounded),
                          ),
                          Tab(
                            icon: Icon(Icons.grid_view_rounded),
                          ),
                          Tab(
                            icon: Icon(Icons.book_rounded),
                          ),
                        ],
                      ),
                    ),
                    const Expanded(
                      child: TabBarView(
                        children: [
                          ListProfilePost(),
                          GridProfilePost(),
                          BookAuthor()
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
