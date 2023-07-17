import 'package:bitread_app/screen/forgot_password_screen.dart';
import 'package:bitread_app/screen/register_screen.dart';
import 'package:bitread_app/widget/bottom_navigation.dart';
import 'package:bitread_app/widget/custom_button.dart';
import 'package:bitread_app/widget/custom_text_field.dart';
import 'package:bitread_app/widget/google_button.dart';
import 'package:bitread_app/widget/password_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  late String email;
  late String password;
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  Future<void> signin(
      BuildContext context, String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const BottomNav(),
        ),
        (route) => false,
      );
    } on FirebaseAuthException catch (error) {
      Fluttertoast.showToast(
          msg: error.message.toString(),
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const BottomNav(),
      ),
      (route) => false,
    );
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 18,
                        ),
                        CustomTextField(
                          icon: Icons.email,
                          hintText: 'Email',
                          onChanged: (value) {
                            email = value.trim();
                          },
                          validator: (value) {
                            final emailRegex = RegExp(
                                r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                            if (value == null || value.isEmpty) {
                              return 'Email Tidak Boleh Kosong!';
                            } else if (!emailRegex.hasMatch(value)) {
                              return 'Masukkan Alamat Email Dengan Benar!';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        PasswordTextField(
                          hintText: 'Password',
                          icon: Icons.lock,
                          onChanged: (value) {
                            password = value.trim();
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Masukkan Password Anda';
                            } else if (value.length < 6) {
                              return 'Password harus terdiri dari 6 karakter!';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ForgotPassScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              'Lupa Password?',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 14),
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
                            if (formKey.currentState!.validate()) {
                              signin(context, email, password);
                            }
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
                              "atau",
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
                          press: () {
                            signInWithGoogle();
                          },
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
                                    builder: (context) =>
                                        const RegisterScreen(),
                                  ),
                                );
                              },
                              child: const Text("Daftar disini"),
                            ),
                          ],
                        ),
                      ],
                    ),
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
