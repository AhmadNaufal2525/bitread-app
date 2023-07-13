import 'package:bitread_app/screen/login_screen.dart';
import 'package:bitread_app/widget/custom_button.dart';
import 'package:flutter/material.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key});

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.center,
              child: Text(
                'Profile',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 22),
              ),
            ),
            const SizedBox(
              height: 220,
              child: Center(
                child: CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: 80,
                  backgroundImage: AssetImage('assets/profil.png'),
                ),
              ),
            ),
            const Text(
              'John Doe',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'johndoe@gmail.com',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      'Posts',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '230',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 28),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 36),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Social Media',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Row(
                      children: [
                        Icon(
                          Icons.facebook,
                          size: 24,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'facebook.com/johndoe',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Row(
                      children: [
                        Icon(
                          Icons.mail,
                          size: 24,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'twitter.com/johndoe',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 60),
                    Center(
                      child: CustomButton(
                        text: ('Logout'),
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const LoginScreen(),
                            ),
                            (route) => false,
                          );
                        },
                        color: const Color(0xffFE0002),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
