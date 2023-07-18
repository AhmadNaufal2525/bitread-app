import 'package:bitread_app/screen/home_screen.dart';
import 'package:bitread_app/screen/news_screen.dart';
import 'package:bitread_app/screen/profile_screen.dart';
import 'package:bitread_app/screen/search_screen.dart';
import 'package:flutter/material.dart';

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
      pageController.animateToPage(index,
          duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    });
  }

  List<BottomNavigationBarItem> buildBottomNavBarItems() {
    return [
      const BottomNavigationBarItem(
        icon: Icon(
          Icons.home_filled,
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
          Icons.newspaper_rounded,
        ),
        label: 'Blog',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.person_2_rounded),
        label: 'Profile',
      ),
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
        children: const <Widget>[
          HomeScreen(),
          SearchSreen(),
          NewsScreen(),
          ProfilScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        onTap: (index) {
          bottomTapped(index);
        },
        unselectedItemColor: Colors.grey,
        selectedItemColor: const Color(0xffFE0002),
        items: buildBottomNavBarItems(),
      ),
    );
  }
}
