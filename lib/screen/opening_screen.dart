import 'package:animate_do/animate_do.dart';
import 'package:bitread_app/screen/login_screen.dart';
import 'package:bitread_app/screen/register_screen.dart';
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
    return Scaffold(
      backgroundColor: const Color(0xffFE0002),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
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
              const SizedBox(height: 20),
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
              const SizedBox(height: 24),
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
                height: MediaQuery.of(context).size.height * 0.25,
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
      ),
    );
  }
}
