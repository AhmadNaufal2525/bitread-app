import 'package:bitread_app/widget/custom_button.dart';
import 'package:bitread_app/widget/star_rating.dart';
import 'package:flutter/material.dart';

class BookDetailScreen extends StatelessWidget {
  final String id;
  final String title;
  final String rating;
  final String imageUrl;
  final String author;
  final String desc;
  const BookDetailScreen(
      {super.key,
      required this.title,
      required this.rating,
      required this.imageUrl,
      required this.author,
      required this.desc,
      required this.id});

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
                imageUrl,
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
                            title,
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
                          author,
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
                            const StarRating(
                              rating: 5,
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            Text(
                              rating,
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
                      desc,
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
                            onPressed: () {},
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
                            onPressed: () {},
                            text: 'Beli Buku',
                            icon: const Icon(Icons.trolley),
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
