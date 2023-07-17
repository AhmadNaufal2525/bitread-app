import 'package:bitread_app/screen/login_screen.dart';
import 'package:bitread_app/widget/custom_button.dart';
import 'package:bitread_app/widget/custom_text_field.dart';
import 'package:bitread_app/widget/google_button.dart';
import 'package:bitread_app/widget/password_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();
  late String username;
  late String email;
  late String password;
  late String confPassword;
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  Future<void> registerUser(BuildContext context, String username, String email,
      String password) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      user?.updateDisplayName(username);
      String id = user?.uid ?? '';
      await firestore.collection('User').doc(user?.uid).set(
        {'id': id, 'username': username, 'email': email, 'image': ''},
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => const LoginScreen()),
        (route) => false,
      );

      Fluttertoast.showToast(
        msg: "Daftar Akun Berhasil!",
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    } on FirebaseAuthException catch (error) {
      Fluttertoast.showToast(
        msg: error.message.toString(),
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
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
                Align(
                  alignment: AlignmentDirectional.topStart,
                  child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.arrow_back)),
                ),
                const Center(
                  child: Text(
                    'DAFTAR AKUN',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
                  ),
                ),
                Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        CustomTextField(
                          icon: Icons.person,
                          hintText: 'Username',
                          onChanged: (value) {
                            username = value.trim();
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Username Tidak Boleh Kosong!';
                            } else if (value.length < 6) {
                              return 'Username harus terdiri dari 6 karakter!';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
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
                              return 'Password Tidak Boleh Kosong!';
                            } else if (value.length < 6) {
                              return 'Password harus terdiri dari 6 karakter atau lebih';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        PasswordTextField(
                          hintText: 'Confirm Password',
                          icon: Icons.lock,
                          onChanged: (value) {
                            confPassword = value.trim();
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Confirm Password Tidak Boleh Kosong!';
                            } else if (value != password) {
                              return 'Password tidak sama!';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: RichText(
                            textAlign: TextAlign.justify,
                            text: TextSpan(
                              text:
                                  'Dengan mendaftarkan akun, anda telah menyetujui untuk menerima ',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                  fontSize: 14),
                              children: [
                                TextSpan(
                                  text: 'Privacy Policy Bitread',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontFamily:
                                        GoogleFonts.poppins().fontFamily,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        CustomButton(
                          color: const Color(0xffFE0002),
                          text: 'Daftar',
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              registerUser(context, username, email, password);
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
                          press: () {},
                          textColor: const Color.fromARGB(255, 12, 12, 12),
                          color: const Color(0xffFFFFFF),
                          text: 'Sign Up with Google',
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Text("Sudah punya akun?"),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ),
                                );
                              },
                              child: const Text("Masuk disini"),
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
