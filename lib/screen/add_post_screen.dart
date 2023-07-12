import 'package:bitread_app/widget/custom_button.dart';
import 'package:flutter/material.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  AddPostScreenState createState() => AddPostScreenState();
}

class AddPostScreenState extends State<AddPostScreen> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double screenWidth = mediaQueryData.size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back),
                      ),
                      const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 82, vertical: 10),
                        child: Text(
                          'Posting Blog',
                          style: TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 16),
                        ),
                      )
                    ],
                  ),
                  Image.asset(
                    'assets/add_image.png',
                    height: 120,
                    width: 120,
                    fit: BoxFit.fill,
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    onPressed: () {},
                    text: 'Tambah Gambar',
                    width: screenWidth * 0.5,
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Title'),
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Author'),
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    maxLength: 2500,
                    maxLines: 5,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Isi Post'),
                  ),
                  const SizedBox(height: 30),
                  CustomButton(text: 'Post', onPressed: () {})
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
