import 'package:bitread_app/screen/home_screen.dart';
import 'package:bitread_app/screen/news_screen.dart';
import 'package:bitread_app/screen/profile_screen.dart';
import 'package:floating_navbar/floating_navbar.dart';
import 'package:floating_navbar/floating_navbar_item.dart';
import 'package:flutter/material.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FloatingNavBar(
        color: Colors.white,
        selectedIconColor: Colors.blue,
        unselectedIconColor: Colors.grey,
        borderRadius: 20,
        horizontalPadding: 10,
        resizeToAvoidBottomInset: false,
        hapticFeedback: true,
        items: [
          FloatingNavBarItem(
            iconData: Icons.home_filled,
            title: 'Beranda',
            page: const HomeScreen(),
          ),
          FloatingNavBarItem(
            iconData: Icons.newspaper,
            title: 'Berita',
            page: const NewsScreen(),
          ),
          FloatingNavBarItem(
            iconData: Icons.person_2_rounded,
            title: 'Profil',
            page: const ProfilScreen(),
          ),
        ],
      ),
    );
  }
}
