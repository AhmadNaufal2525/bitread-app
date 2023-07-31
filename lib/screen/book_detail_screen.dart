import 'package:bitread_app/screen/pdfviewer.dart';
import 'package:bitread_app/widget/custom_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class BookDetailScreen extends StatefulWidget {
  final String id;
  final String title;
  final double rating;
  final String imageUrl;
  final String author;
  final String desc;
  final String url;
  const BookDetailScreen(
      {super.key,
      required this.title,
      required this.rating,
      required this.imageUrl,
      required this.author,
      required this.desc,
      required this.id,
      required this.url});

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  Future<void> openPdfFromFirebase(BuildContext context) async {
    try {
      CollectionReference booksCollection =
          FirebaseFirestore.instance.collection('Books');
      DocumentSnapshot bookSnapshot =
          await booksCollection.doc(widget.id).get();
      if (bookSnapshot.exists) {
        String pdfUrl = bookSnapshot.get('ebook');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PdfViewer(pdfUrl: pdfUrl),
          ),
        );
      } else {
        throw Exception('Book document with ID $widget.id does not exist.');
      }
    } catch (e) {
      throw Exception('Error loading PDF: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Detail Buku',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Image.network(
                widget.imageUrl,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.fitWidth,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            widget.title,
                            style: const TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w700,
                                fontSize: 21),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          widget.author,
                          style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: <Widget>[
                        const Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            RatingBar.builder(
                              initialRating: widget.rating,
                              direction: Axis.horizontal,
                              itemCount: 5,
                              itemSize: 20.0,
                              itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              ignoreGestures: true,
                              onRatingUpdate: (double value) {},
                            ),
                            Text(
                              widget.rating.toString(),
                              style: const TextStyle(
                                color: Color.fromARGB(255, 0, 133, 69),
                                fontSize: 14,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      widget.desc,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 18,
                        letterSpacing: 0.6,
                        wordSpacing: 0.6,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(
                      height: 80,
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: CustomButton(
                            onPressed: () {
                              openPdfFromFirebase(context);
                            },
                            text: 'Baca Buku',
                            icon: const Icon(Icons.menu_book),
                            color: const Color(0xffFE0002),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: CustomButton(
                            onPressed: () async {
                              final url = Uri.parse(widget.url);
                              await launchUrl(url);
                            },
                            text: 'Beli Buku',
                            icon: const Icon(Icons.shopping_bag_sharp),
                            color: Colors.grey,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
