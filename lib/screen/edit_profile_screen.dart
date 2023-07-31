import 'dart:io';
import 'package:bitread_app/widget/custom_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  final String id;
  final String username;
  final String email;
  final String image;
  const EditProfile({
    super.key,
    required this.username,
    required this.email,
    required this.image,
    required this.id,
  });

  @override
  State<EditProfile> createState() => EditProfileState();
}

class EditProfileState extends State<EditProfile> {
  String selectedImagePath = '';
  late String username;
  late String email;
  late String image;
  final formKey = GlobalKey<FormState>();

  Future<void> updateProfile() async {
    try {
      final docRef =
          FirebaseFirestore.instance.collection('User').doc(widget.id);
      Map<String, dynamic> dataToUpdate = {
        'username': username,
        'email': email,
      };

      if (selectedImagePath != '') {
        final ref = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child('${widget.id}.jpg');
        final uploadTask = ref.putFile(File(selectedImagePath));
        final snapshot = await uploadTask.whenComplete(() => null);
        final image = await snapshot.ref.getDownloadURL();
        dataToUpdate['image'] = image;
      }
      await docRef.update(dataToUpdate);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data berhasil diperbarui')),
      );
      Navigator.pop(context);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $error')),
      );
    }
  }

  @override
  void initState() {
    username = widget.username;
    email = widget.email;
    image = widget.image;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double screenWidth = mediaQueryData.size.width;
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 60,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: const Text(
            'Edit Profile',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900),
          ),
          leading: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          iconTheme: const IconThemeData(color: Colors.black),
          shadowColor: Colors.transparent,
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  (image != '' && selectedImagePath == '')
                      ? CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey,
                          backgroundImage: NetworkImage(image),
                        )
                      : (selectedImagePath != '')
                          ? CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.grey,
                              backgroundImage:
                                  FileImage(File(selectedImagePath)),
                            )
                          : const CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.grey,
                              backgroundImage: AssetImage('assets/user.png'),
                            ),
                  const SizedBox(height: 20),
                  CustomButton(
                    onPressed: () {
                      selectImage();
                    },
                    text: 'Tambah Gambar',
                    width: screenWidth * 0.5,
                    color: const Color(0xffFE0002),
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Email'),
                    initialValue: email,
                    readOnly: true,
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
                  const SizedBox(height: 30),
                  TextFormField(
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Username'),
                    initialValue: username,
                    onChanged: (value) {
                      username = value.trim();
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Username tidak boleh kosong!';
                      } else if (value.length < 6) {
                        return 'Username harus terdiri dari 6 karakter!';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  CustomButton(
                    text: 'Edit',
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        updateProfile();
                      }
                    },
                    color: const Color(0xffFE0002),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  void selectImage() async {
    selectedImagePath = (await selectImageFromGallery())!;
    if (selectedImagePath != '') {
      setState(
        () {},
      );
    } else {
      setState(
        () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Tidak Ada Gambar Yang Dipilih!"),
              backgroundColor: Colors.red,
            ),
          );
        },
      );
    }
  }

  Future<String?> selectImageFromGallery() async {
    final XFile? file = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 10);
    if (file != null) {
      return file.path;
    } else {
      return null;
    }
  }
}
