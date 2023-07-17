import 'package:bitread_app/widget/custom_button.dart';
import 'package:bitread_app/widget/custom_text_field.dart';
import 'package:bitread_app/widget/success_dialog.dart';
import 'package:flutter/material.dart';

class ForgotPassScreen extends StatefulWidget {
  const ForgotPassScreen({super.key});

  @override
  State<ForgotPassScreen> createState() => _ForgotPassScreenState();
}

class _ForgotPassScreenState extends State<ForgotPassScreen> {
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
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      CustomTextField(
                        icon: Icons.email,
                        hintText: 'Email',
                        onChanged: (String value) {},
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(5),
                        child: Text('Pastikan Email akunmu sudah terdaftar'),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      CustomButton(
                        color: const Color(0xffFE0002),
                        text: 'Kirim',
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => const SuccessDialog(
                                message:
                                    'Silahkan cek email kamu untuk melakukan perubahan password'),
                          );
                        },
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
