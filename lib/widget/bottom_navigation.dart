import 'package:bitread_app/screen/home_screen.dart';
import 'package:bitread_app/screen/post_screen.dart';
import 'package:bitread_app/screen/profile_screen.dart';
import 'package:bitread_app/screen/search_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
      pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
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
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: (index) {
          pageChanged(index);
        },
        children: buildPages(),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        color: const Color(0xffFE0002),
        buttonBackgroundColor: const Color(0xffFE0002),
        height: 60,
        animationDuration: const Duration(milliseconds: 300),
        animationCurve: Curves.easeInOut,
        index: selectedIndex,
        onTap: (index) {
          bottomTapped(index);
        },
        items: buildBottomNavBarItems(),
      ),
    );
  }

  List<Widget> buildBottomNavBarItems() {
    return [
      const Icon(
        Icons.home_rounded,
        size: 30,
        color: Colors.white,
      ),
      const Icon(
        Icons.search_rounded,
        size: 30,
        color: Colors.white,
      ),
      const Icon(
        Icons.newspaper_rounded,
        size: 30,
        color: Colors.white,
      ),
      StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
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
                radius: 20,
                backgroundColor: Colors.grey,
                backgroundImage: NetworkImage(imageURL),
              );
            }
          }
          return const Icon(
            Icons.person_2_rounded,
            size: 30,
            color: Colors.white,
          );
        },
      )
    ];
  }
}
