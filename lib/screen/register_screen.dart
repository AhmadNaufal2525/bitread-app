import 'package:bitread_app/screen/login_screen.dart';
import 'package:bitread_app/widget/custom_button.dart';
import 'package:bitread_app/widget/custom_text_field.dart';
import 'package:bitread_app/widget/google_button.dart';
import 'package:flutter/material.dart';

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
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 30,
                ),
                Align(
                  alignment: AlignmentDirectional.topStart,
                  child: IconButton(
                      onPressed: () {}, icon: Icon(Icons.arrow_back)),
                ),
                SizedBox(
                  height: 30,
                ),
                Center(
                  child: Text(
                    'DAFTAR AKUN',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 32),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 18,
                      ),
                      CustomTextField(
                        icon: Icons.person,
                        hintText: 'Username',
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      CustomTextField(
                        icon: Icons.email,
                        hintText: 'Email',
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      CustomTextField(
                        icon: Icons.lock,
                        hintText: 'Password',
                        obscureText: true,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      CustomTextField(
                        icon: Icons.lock,
                        hintText: 'Confirm Password',
                        obscureText: true,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      CustomButton(
                        width: MediaQuery.of(context).size.width * 1,
                        height: MediaQuery.of(context).size.height * 0.07,
                        text: 'Sign In',
                        onPressed: () {},
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                          'Dengan mendaftarkan akun, anda telah menyetujui untuk menerima Kebijakan Privasi Policy'),
                      GoogleButton(
                        press: () {},
                        textColor: Color(0xffC65B56),
                        color: Color(0xffF6E8EA),
                        text: 'Sign In with Google',
                      ),
                      SizedBox(
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
