import 'package:bitread_app/screen/register_screen.dart';
import 'package:bitread_app/widget/bottom_navigation.dart';
import 'package:bitread_app/widget/custom_button.dart';
import 'package:bitread_app/widget/custom_text_field.dart';
import 'package:bitread_app/widget/google_button.dart';
import 'package:bitread_app/widget/password_text_field.dart';
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
                      CustomTextField(
                        icon: Icons.person,
                        hintText: 'Username',
                        onChanged: (value) {},
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      PasswordTextField(
                        hintText: 'Password',
                        icon: Icons.lock,
                        onChanged: (String value) {},
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Lupa Password?',
                            style: TextStyle(color: Colors.black, fontSize: 14),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomButton(
                        color: const Color(0xffFE0002),
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
                        height: 16,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(
                                  left: 10.0, right: 20.0),
                              child: const Divider(
                                color: Colors.grey,
                                height: 36,
                              ),
                            ),
                          ),
                          const Text(
                            "Masuk dengan",
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(
                                  left: 20.0, right: 10.0),
                              child: const Divider(
                                color: Colors.grey,
                                height: 36,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      GoogleButton(
                        press: () {},
                        textColor: const Color.fromARGB(255, 12, 12, 12),
                        color: const Color(0xffFFFFFF),
                        text: 'Sign In with Google',
                      ),
                      const SizedBox(
                        height: 20,
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
