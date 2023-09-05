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
    return Scaffold(
      backgroundColor: const Color(0xffFE0002),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double w = constraints.maxWidth;
          double h = constraints.maxHeight;

          return Stack(
            children: [
              Column(
                children: [
                  SizedBox(
                    height: h * 0.06,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: const Icon(
                        Icons.info,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const About(),
                          ),
                        );
                      },
                    ),
                  ),
                  FadeIn(
                    child: Image.asset(
                      'assets/logo_bitread.png',
                      width: w * 0.4, // Sesuaikan ukuran gambar
                    ),
                  ),
                  SizedBox(
                    height: h * 0.04,
                  ),
                  BounceInDown(
                    child: Center(
                      child: Image.asset(
                        'assets/opening.png',
                        width: w * 0.6, // Sesuaikan ukuran gambar
                        height: w * 0.6,
                      ),
                    ),
                  ),
                  SizedBox(height: h * 0.06),
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
                      width: w * 0.67,
                      height: h * 0.07,
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
                      width: w * 0.67,
                      height: h * 0.07,
                      color: Colors.white,
                      textColor: Colors.black,
                    ),
                  ),
                ],
              ),
              const Positioned(
                left: 70,
                right: 0,
                bottom: 36,
                child: Text(
                  'Bitread All Right Reserved @2023',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
