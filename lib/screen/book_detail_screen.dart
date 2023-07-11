import 'package:bitread_app/widget/star_rating.dart';
import 'package:flutter/material.dart';

class BookDetailScreen extends StatelessWidget {
  final String title;
  final String rating;
  final String imageUrl;
  final String author;

  const BookDetailScreen(
      {super.key,
      required this.title,
      required this.rating,
      required this.imageUrl,
      required this.author});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Image.asset(
                    imageUrl,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.fitWidth,
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
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
                                  fontSize: 14),
                            )
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      "“The Little Mermaid” is a fairy tale written by the Danish author Hans Christian Andersen. The story follows the journey of a young mermaid who is willing to give up her life in the sea as a mermaid to gain a human soul. The tale was first published in 1837 as part of a collection of fairy tales for children.",
                      style: TextStyle(
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
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 0, 133, 69),
                                borderRadius: BorderRadius.circular(12)),
                            child: const Text(
                              "Baca Buku",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.grey, width: 2),
                                borderRadius: BorderRadius.circular(12)),
                            child: InkWell(
                              onTap: () {},
                              child: const Text(
                                "Beli Buku",
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
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
