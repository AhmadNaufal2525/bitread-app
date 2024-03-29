import 'dart:io';
import 'package:bitread_app/widget/custom_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quickalert/quickalert.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  AddPostScreenState createState() => AddPostScreenState();
}

class AddPostScreenState extends State<AddPostScreen> {
  String selectedImagePath = '';
  late String judul;
  late String isiBlog;
  final formKey = GlobalKey<FormState>();

  Future<void> addNewPost() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      String? userId = user?.uid;
      DocumentSnapshot userSnapshot =
          await FirebaseFirestore.instance.collection('User').doc(userId).get();

      if (!userSnapshot.exists) {
        throw Exception('Pengguna tidak ditemukan');
      }

      String? displayName = userSnapshot.get('username');
      String? authorImageURL = userSnapshot.get('image');

      QuerySnapshot existingPosts = await FirebaseFirestore.instance
          .collection('Post Blog')
          .where('judul', isEqualTo: judul)
          .get();
      if (existingPosts.docs.isNotEmpty) {
        setState(
          () {
            warningAlert();
          },
        );
      } else {
        final newPost =
            await FirebaseFirestore.instance.collection('Post Blog').add({
          'userId': userId,
          'judul': judul,
          'isiBlog': isiBlog,
          'author': displayName,
          'authorImage': authorImageURL,
          'image_filename': '',
          'imageURL': selectedImagePath,
          'Likes': [],
          'timestamp': FieldValue.serverTimestamp(),
        });
        final String id = newPost.id;
        final ref = FirebaseStorage.instance
            .ref()
            .child('post_images')
            .child('$id.jpg');
        final uploadTask = ref.putFile(File(selectedImagePath));
        final snapshot = await uploadTask.whenComplete(() => null);
        final image = await snapshot.ref.getDownloadURL();
        await FirebaseFirestore.instance
            .collection('Post Blog')
            .doc(id)
            .update({
          'id': id,
          'imageURL': image,
          'image_filename': '$id.jpg',
        });

        setState(
          () {
            FocusScope.of(context).unfocus();
            successAlert();
          },
        );
      }
    } catch (error) {
      errorAlert();
    }
  }

  void successAlert() {
    QuickAlert.show(
      context: context,
      title: 'Success',
      text: "Postingan Blog Mu Berhasil di Upload!",
      type: QuickAlertType.success,
      confirmBtnText: 'Ok',
      onConfirmBtnTap: () {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
    );
  }

  void errorAlert() {
    QuickAlert.show(
      context: context,
      title: 'Gagal',
      text: 'Terjadi kesalahan, Coba untuk upload ulang kembali',
      type: QuickAlertType.error,
      confirmBtnText: 'Ok',
      onConfirmBtnTap: () {
        Navigator.of(context).pop();
      },
    );
  }

  void warningAlert() {
    QuickAlert.show(
      context: context,
      title: 'Peringatan!',
      text: 'Postingan dengan judul ini sudah ada!',
      type: QuickAlertType.warning,
      confirmBtnText: 'Ok',
      onConfirmBtnTap: () {
        Navigator.of(context).pop();
      },
    );
  }

  void deniedAlert() {
    QuickAlert.show(
      context: context,
      title: 'Izin Ditolak',
      text:
          'Izin untuk mengakses penyimpanan secara permanen ditolak. Anda dapat mengaktifkannya di pengaturan aplikasi.',
      type: QuickAlertType.error,
      confirmBtnText: 'Ok',
      onConfirmBtnTap: () {
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double screenWidth = mediaQueryData.size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        title: const Text(
          'Posting Blog',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        shadowColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                (selectedImagePath != '')
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
                  text: 'Pilih Gambar',
                  width: screenWidth * 0.5,
                  color: const Color(0xffFE0002),
                ),
                const SizedBox(height: 30),
                TextFormField(
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
                  text: 'Post',
                  onPressed: () async {
                    if (await Permission.storage.request().isGranted) {
                      if (selectedImagePath.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Color(0xffFE0002),
                            content: Text('Pilih gambar terlebih dahulu!'),
                          ),
                        );
                        return;
                      }
                      if (formKey.currentState!.validate()) {
                        addNewPost();
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Color(0xffFE0002),
                          content: Text(
                              'Izinkan akses penyimpanan untuk memilih gambar!'),
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
    var storageStatus = await Permission.storage.request();

    if (storageStatus.isGranted) {
      selectedImagePath = (await selectImageFromGallery())!;

      if (selectedImagePath != '') {
        setState(() {});
      } else {
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Tidak Ada Gambar Yang Dipilih!"),
              backgroundColor: Colors.red,
            ),
          );
        });
      }
    } else {
      if (storageStatus.isPermanentlyDenied) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                "Permission to access storage is required to select an image."),
            action: SnackBarAction(
              label: 'Enable',
              onPressed: () {
                openAppSettings();
              },
            ),
          ),
        );
      } else {
        deniedAlert();
      }
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
