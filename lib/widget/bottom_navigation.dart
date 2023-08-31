import 'package:bitread_app/screen/home/home_screen.dart';
import 'package:bitread_app/screen/post/post_screen.dart';
import 'package:bitread_app/screen/profile/profile_screen.dart';
import 'package:bitread_app/screen/search/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int selectedIndex = 0;
  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  void pageChanged(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void bottomTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  List<Widget> buildPages() {
    return const <Widget>[
      HomeScreen(),
      SearchSreen(),
      PostScreen(),
      ProfilScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: buildPages(),
      ),
      bottomNavigationBar: SizedBox(
        height: 76,
        child: BottomNavigationBar(
          unselectedFontSize: 12,
          selectedFontSize: 12,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xffFE0002),
          unselectedItemColor: Colors.black,
          showUnselectedLabels: true,
          currentIndex: selectedIndex,
          onTap: (index) {
            bottomTapped(index);
          },
          items: buildBottomNavBarItems(),
        ),
      ),
    );
  }

  List<BottomNavigationBarItem> buildBottomNavBarItems() {
    return [
      const BottomNavigationBarItem(
        icon: Icon(
          Icons.home_rounded,
        ),
        label: 'Home',
      ),
      const BottomNavigationBarItem(
        icon: Icon(
          Icons.search_rounded,
        ),
        label: 'Search',
      ),
      const BottomNavigationBarItem(
        icon: Icon(
          Icons.article_rounded,
        ),
        label: 'Blog',
      ),
      buildProfileNavigationBarItem(),
    ];
  }

  BottomNavigationBarItem buildProfileNavigationBarItem() {
    return BottomNavigationBarItem(
      icon: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('User')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasData && snapshot.data!.exists) {
            var userData = snapshot.data!.data();
            String? imageURL = userData?['image'];
            if (imageURL != null && imageURL.isNotEmpty) {
              return CircleAvatar(
                radius: 16,
                backgroundColor: Colors.grey,
                backgroundImage: CachedNetworkImageProvider(imageURL),
              );
            }
          }
          return const Icon(
            Icons.person_2_rounded,
          );
        },
      ),
      label: 'Profile',
    );
  }
}
