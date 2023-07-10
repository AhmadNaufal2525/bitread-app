import 'package:bitread_app/screen/login_screen.dart';
import 'package:bitread_app/widget/custom_button.dart';
import 'package:bitread_app/widget/custom_text_field.dart';
import 'package:bitread_app/widget/google_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const CustomTextField(
                        icon: Icons.person,
                        hintText: 'Username',
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const CustomTextField(
                        icon: Icons.email,
                        hintText: 'Email',
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
                      const CustomTextField(
                        icon: Icons.lock,
                        hintText: 'Confirm Password',
                        obscureText: true,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomButton(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.height * 0.07,
                        text: 'Daftar',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                          padding: EdgeInsets.all(5),
                          child: RichText(
                            textAlign: TextAlign.justify,
                            text: TextSpan(
                              text:
                                  'Dengan mendaftarkan akun, anda telah menyetujui untuk menerima ',
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: GoogleFonts.poppins().fontFamily,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Privacy Police Bitread',
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontFamily:
                                          GoogleFonts.poppins().fontFamily),
                                ),
                              ],
                            ),
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      GoogleButton(
                        press: () {},
                        textColor: const Color(0xffC65B56),
                        color: const Color(0xffF6E8EA),
                        text: 'Sign In with Google',
                      ),
                      const SizedBox(
                        height: 10,
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
