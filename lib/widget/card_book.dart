import 'package:flutter/material.dart';

class BookCard extends StatelessWidget {
  final String title;
  final String author;
  final double rating;
  final String? imageUrl;

  const BookCard({
    super.key,
    required this.title,
    required this.author,
    required this.rating,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: imageUrl != null && imageUrl!.isNotEmpty
                ? Image.network(
                    imageUrl!,
                    height: 160,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    'assets/book_images.png',
                    height: 160,
                    fit: BoxFit.cover,
                  ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12.0),
            Text(
              title.isNotEmpty ? '${title.substring(0, 12)}...' : 'Title',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              author.isNotEmpty && author.length > 14
                  ? '${author.substring(0, 12)}...'
                  : 'Author',
              style: const TextStyle(
                fontSize: 14.0,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                const Icon(
                  Icons.star,
                  color: Colors.orange,
                  size: 16.0,
                ),
                const SizedBox(width: 4.0),
                Text(
                  rating.toString(),
                  style: const TextStyle(
                    fontSize: 12.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
