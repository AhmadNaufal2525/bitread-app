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
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Posting Blog',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
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
                        border: OutlineInputBorder(), labelText: 'Judul Blog'),
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    maxLength: 2500,
                    maxLines: 10,
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
