import 'package:flutter/material.dart';
import 'package:bitread_app/widget/pdfviewer.dart';
import 'package:bitread_app/widget/custom_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

class BookDetailScreen extends StatefulWidget {
  final String id;
  final String title;
  final double rating;
  final String imageUrl;
  final String author;
  final String desc;
  final String url;
  const BookDetailScreen({
    super.key,
    required this.title,
    required this.rating,
    required this.imageUrl,
    required this.author,
    required this.desc,
    required this.id,
    required this.url,
  });

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
        setState(
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PdfViewer(pdfUrl: pdfUrl),
              ),
            );
          },
        );
      } else {
        setState(() {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.info,
            title: 'E-Book',
            text:
                'E-Book untuk buku ini belum tersedia. Harap bersabar untuk menunggu penerbit mengunggah E-Book. Terima kasih atas pengertian Anda!',
          );
        });
      }
    } catch (e) {
      throw Exception('Error loading PDF: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              pinned: true,
              shadowColor: Colors.transparent,
              expandedHeight: 280,
              flexibleSpace: FlexibleSpaceBar(
                background: CachedNetworkImage(
                  imageUrl: widget.imageUrl,
                  fit: BoxFit.contain,
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              backgroundColor: Colors.white,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 20),
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
                                  if (widget.url.isNotEmpty) {
                                    final url = Uri.parse(widget.url);
                                    await launchUrl(url);
                                  } else {
                                    QuickAlert.show(
                                      context: context,
                                      type: QuickAlertType.info,
                                      title: 'Pembelian Buku',
                                      text:
                                          'Link untuk Pembelian Buku ini belum tersedia. Coba Lagi Nanti Ya!',
                                    );
                                  }
                                },
                                text: 'Beli Buku',
                                icon: const Icon(Icons.shopping_bag_sharp),
                                color: Colors.green,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
