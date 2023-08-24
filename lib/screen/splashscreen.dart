import 'dart:async';
import 'package:bitread_app/screen/opening_screen.dart';
import 'package:bitread_app/widget/bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );
    openSplashScreen();
  }

  openSplashScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    var durasiSplash = const Duration(seconds: 2);
    return Timer(
      durasiSplash,
      () async {
        var storagePermissionStatus = await Permission.storage.request();

        if (storagePermissionStatus.isGranted) {
          setState(() {
            isLoading = false;
          });
          if (isLoggedIn) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) {
                  return const BottomNav();
                },
              ),
            );
          } else {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) {
                  return const OpeningScreen();
                },
              ),
            );
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFE0002),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/logo.jpg'),
                if (isLoading)
                  const CircularProgressIndicator(
                    color: Colors.white,
                  )
              ],
            ),
          ),
          const Positioned(
            left: 0,
            right: 0,
            bottom: 36,
            child: Text(
              'Versi Aplikasi\n1.0.0',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
