import 'package:bitread_app/screen/register_screen.dart';
import 'package:bitread_app/widget/bottom_navigation.dart';
import 'package:bitread_app/widget/custom_button.dart';
import 'package:bitread_app/widget/custom_text_field.dart';
import 'package:bitread_app/widget/google_button.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 30,
                ),
                Center(
                  child: Image.asset(
                    'assets/logo.png',
                    height: 200,
                    width: 200,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 18,
                      ),
                      const CustomTextField(
                        icon: Icons.person,
                        hintText: 'Username',
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const CustomTextField(
                        icon: Icons.lock,
                        hintText: 'Password',
                        obscureText: true,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      CustomButton(
                        text: 'Masuk',
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const BottomNav(),
                            ),
                            (route) => false,
                          );
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 220.0),
                        child: TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Lupa kata sandi?',
                            style: TextStyle(color: Colors.black, fontSize: 14),
                          ),
                        ),
                      ),
                      GoogleButton(
                        press: () {},
                        textColor: const Color(0xffC65B56),
                        color: const Color(0xffF6E8EA),
                        text: 'Sign In with Google',
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text("Tidak punya akun?"),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RegisterScreen(),
                                ),
                              );
                            },
                            child: const Text("Daftar disini"),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
