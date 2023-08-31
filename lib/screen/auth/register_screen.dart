import 'package:animate_do/animate_do.dart';
import 'package:bitread_app/screen/auth/login_screen.dart';
import 'package:bitread_app/widget/custom_button.dart';
import 'package:bitread_app/widget/custom_text_field.dart';
import 'package:bitread_app/widget/google_button.dart';
import 'package:bitread_app/widget/password_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bitread_app/widget/bottom_navigation.dart';

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
  bool isLoading = false;
  Future<void> setLoggedIn(bool isLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', isLoggedIn);
  }

  Future<void> registerUser(BuildContext context, String username, String email,
      String password) async {
    try {
      setState(() {
        isLoading = true;
      });

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

      setState(
        () {
          FocusScope.of(context).unfocus();
          Navigator.pop(context);
          Fluttertoast.showToast(
            msg: "Daftar Akun Berhasil!",
            gravity: ToastGravity.TOP,
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );

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
      );
    } on FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in-use') {
        Fluttertoast.showToast(
          msg: "Email sudah digunakan. Coba daftar dengan email lain.",
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      } else {
        Fluttertoast.showToast(
          msg: error.message.toString(),
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      setState(() {
        isLoading = true;
      });

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final user = userCredential.user;
      if (user != null) {
        final userRef = FirebaseFirestore.instance.collection('User');
        final existingUser = await userRef.doc(user.uid).get();
        if (!existingUser.exists) {
          await userRef.doc(user.uid).set({
            'id': user.uid,
            'username': user.displayName ?? '',
            'email': user.email ?? '',
            'image': user.photoURL ?? '',
          });
        }
      }
      await setLoggedIn(true);

      setState(() {
        isLoading = false;
      });
      return userCredential;
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      return null;
    }
  }

  checkLoggedInStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (isLoggedIn) {
      setState(() {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => const BottomNav()),
          (route) => false,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 1,
      child: Stack(
        children: [
          Opacity(
            opacity: isLoading ? 0 : 1,
            child: AbsorbPointer(
              absorbing: isLoading,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Form(
                      key: formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                FadeInUp(
                                  child: const Text(
                                    'Register',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    Navigator.pop(
                                      context,
                                    );
                                  },
                                  icon: const Icon(Icons.clear),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            FadeInUp(
                              child: const Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'Silahkan isi kelengkapan akunmu di bawah ini',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 18,
                            ),
                            FadeInUp(
                              child: CustomTextField(
                                icon: Icons.person_2_rounded,
                                hintText: 'Username',
                                onChanged: (value) {
                                  username = value.trim();
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Username Tidak Boleh Kosong!';
                                  } else if (value.length < 8) {
                                    return 'Username harus terdiri dari 8 karakter!';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            FadeInUp(
                              child: CustomTextField(
                                icon: Icons.email_rounded,
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
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            FadeInUp(
                              child: PasswordTextField(
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
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            FadeInUp(
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: RichText(
                                  textAlign: TextAlign.justify,
                                  text: TextSpan(
                                    text:
                                        'Dengan mendaftarkan akun, anda telah menyetujui untuk menerima ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily:
                                            GoogleFonts.poppins().fontFamily,
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
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            FadeInUp(
                              child: CustomButton(
                                color: const Color(0xffFE0002),
                                text: 'Daftar',
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    registerUser(
                                        context, username, email, password);
                                  }
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            FadeInUp(
                              child: Row(
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
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            FadeInUp(
                              child: GoogleButton(
                                press: () {
                                  signInWithGoogle().then(
                                    (userCredential) {
                                      if (userCredential != null) {
                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                const BottomNav(),
                                          ),
                                          (route) => false,
                                        );
                                      } else {
                                        Navigator.pop(context);
                                      }
                                    },
                                  );
                                },
                                textColor:
                                    const Color.fromARGB(255, 12, 12, 12),
                                color: const Color(0xffFFFFFF),
                                text: 'Sign In with Google',
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            FadeInUp(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  const Text("Sudah punya akun?"),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
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
                                    child: const Text("Masuk disini"),
                                  ),
                                ],
                              ),
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
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: SpinKitWave(
                  color: Color(0xffFE0002),
                  size: 50.0,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
