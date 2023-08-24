import 'package:flutter/material.dart';

class NewsEventDetailScreen extends StatelessWidget {
  final String image;
  final String title;
  final String uploadTime;
  final String author;
  final String description;
  final String sourceLink;
  final String tipe;

  const NewsEventDetailScreen({
    Key? key,
    required this.image,
    required this.title,
    required this.uploadTime,
    required this.author,
    required this.description,
    required this.sourceLink,
    required this.tipe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int maxLineLength = 500;
    List<String> words = description.split(' ');
    List<String> paragraphs = [];
    String currentParagraph = '';

    for (String word in words) {
      if (('$currentParagraph $word').length <= maxLineLength) {
        if (currentParagraph.isNotEmpty) {
          currentParagraph += ' ';
        }
        currentParagraph += word;
      } else {
        paragraphs.add(currentParagraph);
        currentParagraph = word;
      }
    }

    if (currentParagraph.isNotEmpty) {
      paragraphs.add(currentParagraph);
    }

    String formattedText = paragraphs.join('\n\n');

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              iconTheme: const IconThemeData(color: Colors.white),
              backgroundColor: Colors.transparent,
              elevation: 0,
              expandedHeight: MediaQuery.of(context).size.height * 0.45,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.network(
                        image,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: Colors.grey.withAlpha(150),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  tipe,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        color: Colors.white,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            uploadTime,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Penulis: $author',
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(
                    height: MediaQuery.of(context).size.height * 2.4,
                    padding: const EdgeInsets.all(20.0),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                      ),
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          formattedText,
                          textAlign: TextAlign.justify,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          sourceLink,
                          textAlign: TextAlign.justify,
                          style: const TextStyle(color: Colors.blue),
                        ),
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
