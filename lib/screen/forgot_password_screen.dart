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
    return SizedBox(
      height: MediaQuery.of(context).size.height * 1,
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
                        const Text(
                          'Reset Password',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
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
                    const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Pastikan email akunmu sudah terdaftar',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 16),
                      ),
                    ),
                    const SizedBox(
                      height: 60,
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
                      height: 60,
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
    );
  }
}
