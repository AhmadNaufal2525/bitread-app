import 'package:animate_do/animate_do.dart';
import 'package:bitread_app/screen/auth/forgot_password_screen.dart';
import 'package:bitread_app/screen/auth/register_screen.dart';
import 'package:bitread_app/widget/bottom_navigation.dart';
import 'package:bitread_app/widget/custom_button.dart';
import 'package:bitread_app/widget/custom_text_field.dart';
import 'package:bitread_app/widget/google_button.dart';
import 'package:bitread_app/widget/password_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  bool isLoading = false;
  Future<void> setLoggedIn(bool isLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', isLoggedIn);
  }

  Future<void> signin(
      BuildContext context, String email, String password) async {
    try {
      setState(() {
        isLoading = true;
      });
      await auth.signInWithEmailAndPassword(email: email, password: password);
      setState(
        () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const BottomNav(),
            ),
            (route) => false,
          );
        },
      );
      await setLoggedIn(true);
    } on FirebaseAuthException catch (error) {
      Fluttertoast.showToast(
          msg: error.message.toString(),
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.red,
          textColor: Colors.white);
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
      setState(
        () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => const BottomNav()),
            (route) => false,
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 1,
      child: Stack(
        children: [
          Opacity(
            opacity: isLoading ? 0.5 : 1.0,
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
                                    'Login',
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
                              height: 10,
                            ),
                            FadeInUp(
                              child: const Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'Masukkan email dan kata sandi akunmu disini',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.05,
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
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.04,
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
                                    return 'Masukkan Password Anda';
                                  } else if (value.length < 6) {
                                    return 'Password harus terdiri dari 6 karakter!';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            FadeInUp(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    showModalBottomSheet(
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(25),
                                        ),
                                      ),
                                      context: context,
                                      builder: (context) =>
                                          const ForgotPassScreen(),
                                    );
                                  },
                                  child: const Text(
                                    'Lupa Password?',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            FadeInUp(
                              child: CustomButton(
                                color: const Color(0xffFE0002),
                                text: 'Masuk',
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    signin(context, email, password);
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
                              height: 26,
                            ),
                            FadeInUp(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  const Text("Tidak punya akun?"),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
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
                                    child: const Text("Daftar disini"),
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
