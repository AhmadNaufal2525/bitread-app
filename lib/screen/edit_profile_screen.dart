import 'dart:io';
import 'package:bitread_app/widget/custom_button.dart';
import 'package:bitread_app/widget/custom_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class EditProfile extends StatefulWidget {
  final String id;
  final String username;
  final String email;
  final String image;
  final String instagram;
  final String twitter;
  final String facebook;
  const EditProfile({
    super.key,
    required this.username,
    required this.email,
    required this.image,
    required this.id,
    required this.instagram,
    required this.twitter,
    required this.facebook,
  });

  @override
  State<EditProfile> createState() => EditProfileState();
}

class EditProfileState extends State<EditProfile> {
  String selectedImagePath = '';
  late String username;
  late String email;
  late String image;
  late String instagramLink;
  late String twitterLink;
  late String facebookLink;
  final formKey = GlobalKey<FormState>();

  Future<void> updateProfile() async {
    try {
      final docRef =
          FirebaseFirestore.instance.collection('User').doc(widget.id);
      final postCollectionRef =
          FirebaseFirestore.instance.collection('Post Blog');
      Map<String, dynamic> dataToUpdate = {
        'username': username,
        'email': email,
        'instagram': instagramLink,
        'twitter': twitterLink,
        'facebook': facebookLink,
      };
      String newImage = '';

      if (selectedImagePath != '') {
        final ref = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child('${widget.id}.jpg');
        final uploadTask = ref.putFile(File(selectedImagePath));
        final snapshot = await uploadTask.whenComplete(() => null);
        newImage = await snapshot.ref.getDownloadURL();
        dataToUpdate['image'] = newImage;
      }

      await docRef.update(dataToUpdate);

      final querySnapshot =
          await postCollectionRef.where('userId', isEqualTo: widget.id).get();

      for (final postDoc in querySnapshot.docs) {
        Map<String, dynamic> postUpdateData = {
          'author': username,
        };

        if (newImage.isNotEmpty) {
          postUpdateData['authorImage'] = newImage;
        }

        await postDoc.reference.update(postUpdateData);
      }

      setState(
        () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Data berhasil diperbarui',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        },
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Terjadi kesalahan, coba lagi nanti',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void initState() {
    username = widget.username;
    email = widget.email;
    image = widget.image;
    instagramLink = widget.instagram;
    twitterLink = widget.twitter;
    facebookLink = widget.facebook;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double screenWidth = mediaQueryData.size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900),
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
                            backgroundImage: FileImage(File(selectedImagePath)),
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
                  text: 'Pilih Gambar',
                  width: screenWidth * 0.5,
                  color: const Color(0xffFE0002),
                ),
                const SizedBox(height: 30),
                CustomTextField(
                  isReadOnly: true,
                  initialValue: email,
                  icon: Icons.email_rounded,
                  hintText: "Email",
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
                CustomTextField(
                  initialValue: username,
                  icon: Icons.person_2_rounded,
                  hintText: 'Username',
                  onChanged: (value) {
                    username = value.trim();
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Username Tidak Boleh Kosong!';
                    } else if (value.length < 8) {
                      return 'Username harus terdiri dari 8 karakter!';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                CustomTextField(
                  initialValue: instagramLink,
                  icon: Icons.link,
                  hintText: 'Link Instagram ',
                  onChanged: (value) {
                    instagramLink = value.trim();
                  },
                ),
                const SizedBox(height: 30),
                CustomTextField(
                  initialValue: twitterLink,
                  icon: Icons.link,
                  hintText: 'Link Twitter',
                  onChanged: (value) {
                    twitterLink = value.trim();
                  },
                ),
                const SizedBox(height: 30),
                CustomTextField(
                  initialValue: facebookLink,
                  icon: Icons.link,
                  hintText: 'Link Facebook',
                  onChanged: (value) {
                    facebookLink = value.trim();
                  },
                ),
                const SizedBox(height: 40),
                CustomButton(
                  text: 'Update',
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      updateProfile();
                    }
                  },
                  color: const Color(0xffFE0002),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void selectImage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Pilih Gambar"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: const Row(
                    children: [
                      Icon(Icons.photo_camera),
                      SizedBox(width: 10),
                      Text("Kamera"),
                    ],
                  ),
                  onTap: () async {
                    Navigator.of(context).pop();
                    if (await Permission.camera.request().isGranted) {
                      selectedImagePath = (await getImageFromCamera())!;
                      if (selectedImagePath != '') {
                        setState(() {});
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Tidak Ada Gambar Yang Dipilih!"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              "Izinkan akses kamera untuk mengambil gambar."),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                ),
                const Padding(padding: EdgeInsets.all(10.0)),
                GestureDetector(
                  child: const Row(
                    children: [
                      Icon(Icons.photo),
                      SizedBox(width: 10),
                      Text("Galeri"),
                    ],
                  ),
                  onTap: () async {
                    Navigator.of(context).pop();
                    if (await Permission.storage.request().isGranted) {
                      selectedImagePath = (await selectImageFromGallery())!;
                      if (selectedImagePath != '') {
                        setState(() {});
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Tidak Ada Gambar Yang Dipilih!"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              "Izinkan akses penyimpanan untuk memilih gambar."),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
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

  Future<String?> getImageFromCamera() async {
    final XFile? file = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 10);
    if (file != null) {
      return file.path;
    } else {
      return null;
    }
  }
}
