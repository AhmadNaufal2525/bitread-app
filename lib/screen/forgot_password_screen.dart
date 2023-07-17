import 'package:bitread_app/widget/custom_button.dart';
import 'package:bitread_app/widget/custom_text_field.dart';
import 'package:bitread_app/widget/failed_dialog.dart';
import 'package:bitread_app/widget/success_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPassScreen extends StatefulWidget {
  const ForgotPassScreen({super.key});

  @override
  State<ForgotPassScreen> createState() => _ForgotPassScreenState();
}

class _ForgotPassScreenState extends State<ForgotPassScreen> {
  final formKey = GlobalKey<FormState>();
  late String email;
  void resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      showDialog(
        context: context,
        builder: (context) => const SuccessDialog(
            message:
                'Silahkan cek email anda untuk melakukan perubahan password'),
      );
    } catch (error) {
      showDialog(
        context: context,
        builder: (context) =>
            const FailedDialog(message: 'Cek Kembali email anda'),
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
              children: [
                Align(
                  alignment: AlignmentDirectional.topStart,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                ),
                const Center(
                  child: Text(
                    'RESET PASSWORD',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
                  ),
                ),
                Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 30,
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
                          height: 30,
                        ),
                        const Padding(
                          padding: EdgeInsets.all(5),
                          child: Text('Pastikan Emailmu sudah terdaftar'),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        CustomButton(
                          color: const Color(0xffFE0002),
                          text: 'Kirim',
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              resetPassword(email);
                            }
                          },
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
