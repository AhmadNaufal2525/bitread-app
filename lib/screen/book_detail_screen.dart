import 'package:bitread_app/widget/bottom_navigation.dart';
import 'package:bitread_app/widget/star_rating.dart';
import 'package:flutter/material.dart';

class BookDetailScreen extends StatefulWidget {
  const BookDetailScreen({super.key});

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Image.asset(
            "assets/book1.jpg",
            width: 200,
            fit: BoxFit.fitWidth,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              children: <Widget>[
                const Row(
                  children: <Widget>[
                    Text(
                      "The Little mermaid",
                      style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w700,
                          fontSize: 21),
                    ),
                    Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        StarRating(
                          rating: 5,
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                          "Fairy Tales",
                          style: TextStyle(
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
                          "Read Book",
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
                              border: Border.all(color: Colors.grey, width: 2),
                              borderRadius: BorderRadius.circular(12)),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const BottomNav(),
                                ),
                              );
                            },
                            child: const Text(
                              "Back",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                            ),
                          )),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
