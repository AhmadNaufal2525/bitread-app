import 'dart:io';

import 'package:bitread_app/widget/custom_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditPost extends StatefulWidget {
  final String id;
  final String title;
  final String description;
  final String image;
  const EditPost(
      {super.key,
      required this.id,
      required this.title,
      required this.description,
      required this.image});

  @override
  State<EditPost> createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {
  String selectedImagePath = '';
  late String judul;
  late String isiBlog;
  late String image;
  final formKey = GlobalKey<FormState>();

  Future<void> updatePost() async {
    try {
      final docRef =
          FirebaseFirestore.instance.collection('Post Blog').doc(widget.id);
      Map<String, dynamic> dataToUpdate = {
        'judul': judul,
        'isiBlog': isiBlog,
      };

      if (selectedImagePath != '') {
        final ref = FirebaseStorage.instance
            .ref()
            .child('post_images')
            .child('${widget.id}.jpg');
        final uploadTask = ref.putFile(File(selectedImagePath));
        final snapshot = await uploadTask.whenComplete(() => null);
        final image = await snapshot.ref.getDownloadURL();
        dataToUpdate['imageURL'] = image;
      }
      await docRef.update(dataToUpdate);
      setState(
        () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Artikel berhasil diperbarui dengan judul $judul',
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
          Navigator.pop(context);
        },
      );
    } catch (error) {
     setState(() {
        ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Terjadi kesalahan, coba lagi nanti',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
     });
    }
  }

  @override
  void initState() {
    judul = widget.title;
    isiBlog = widget.description;
    image = widget.image;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double screenWidth = mediaQueryData.size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 80,
        elevation: 1,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Posting Blog',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                (image != '' && selectedImagePath == '')
                    ? Image.network(
                        image,
                        height: 200,
                        width: 280,
                        fit: BoxFit.fill,
                      )
                    : (selectedImagePath != '')
                        ? Image.file(
                            File(selectedImagePath),
                            height: 200,
                            width: 280,
                            fit: BoxFit.fill,
                          )
                        : Image.asset(
                            'assets/add_image.png',
                            height: 120,
                            width: 120,
                            fit: BoxFit.fill,
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
                  initialValue: judul,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Judul Blog'),
                  onChanged: (value) {
                    judul = value.trim();
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Isi Judul Blog Anda!';
                    } else if (value.length < 10) {
                      return 'Judul minimal harus 10 karakter!';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                TextFormField(
                  initialValue: isiBlog,
                  maxLength: 2500,
                  maxLines: 10,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Isi Blog'),
                  onChanged: (value) {
                    isiBlog = value.trim();
                  },
                  validator: (value) {
                    {
                      if (value == null || value.isEmpty) {
                        return 'Isi blog Anda!';
                      } else if (value.length < 100) {
                        return 'Isi Blog minimal 100 karakter!';
                      }
                      return null;
                    }
                  },
                ),
                const SizedBox(height: 30),
                CustomButton(
                  text: 'Edit',
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      await updatePost();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Color(0xffFE0002),
                          content: Text('Isi field yang masih kosong!'),
                        ),
                      );
                    }
                  },
                  color: const Color(0xffFE0002),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
