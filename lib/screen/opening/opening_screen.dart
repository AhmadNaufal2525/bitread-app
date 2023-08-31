import 'package:animate_do/animate_do.dart';
import 'package:bitread_app/screen/opening/about_us_screen.dart';
import 'package:bitread_app/screen/auth/login_screen.dart';
import 'package:bitread_app/screen/auth/register_screen.dart';
import 'package:bitread_app/widget/custom_button.dart';
import 'package:flutter/material.dart';

class OpeningScreen extends StatefulWidget {
  const OpeningScreen({super.key});

  @override
  State<OpeningScreen> createState() => _OpeningScreenState();
}

class _OpeningScreenState extends State<OpeningScreen> {
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xffFE0002),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: h * 0.03,
            ),
            FadeIn(
              child: Image.asset(
                'assets/logo_bitread.png',
                width: 120,
                height: 120,
              ),
            ),
            BounceInDown(
              child: Center(
                child: Image.asset(
                  'assets/opening.png',
                  width: 260,
                  height: 260,
                ),
              ),
            ),
            SizedBox(height: h * 0.03),
            FadeInUp(
              delay: const Duration(milliseconds: 600),
              child: CustomButton(
                text: 'Login',
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(25),
                      ),
                    ),
                    isScrollControlled: true,
                    builder: (context) {
                      return const FractionallySizedBox(
                        heightFactor: 0.862,
                        child: LoginScreen(),
                      );
                    },
                  );
                },
                width: w * 0.7,
                color: const Color(0xffE97777),
              ),
            ),
            SizedBox(height: h * 0.03),
            FadeInUp(
              delay: const Duration(milliseconds: 600),
              child: CustomButton(
                text: 'Register',
                onPressed: () {
                  showModalBottomSheet(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(25),
                      ),
                    ),
                    isScrollControlled: true,
                    context: context,
                    builder: (context) {
                      return const FractionallySizedBox(
                        heightFactor: 0.862,
                        child: RegisterScreen(),
                      );
                    },
                  );
                },
                width: w * 0.7,
                color: Colors.white,
                textColor: Colors.black,
              ),
            ),
            SizedBox(
              height: h * 0.034,
            ),
            FadeInUp(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const About(),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.group,
                  color: Colors.black,
                ),
                label: const Text(
                  'Tentang Kami',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            SizedBox(
              height: h * 0.16,
            ),
            FadeIn(
              child: const Text(
                'Bitread All Right Reserved @2023',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
