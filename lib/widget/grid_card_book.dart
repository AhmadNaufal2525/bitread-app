import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class GridCardBook extends StatelessWidget {
  final String title;
  final String author;
  final double rating;
  final String? imageUrl;

  const GridCardBook({
    super.key,
    required this.title,
    required this.author,
    required this.rating,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: imageUrl != null && imageUrl!.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: imageUrl!,
                    height: 100,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  )
                : Image.asset(
                    'assets/book_images.png',
                    height: 100,
                    fit: BoxFit.cover,
                  ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title.length > 10 ? '${title.substring(0, 10)}...' : title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12.0,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              author.length > 14 ? '${author.substring(0, 10)}...' : author,
              style: const TextStyle(
                fontSize: 12.0,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                const Icon(
                  Icons.star,
                  color: Colors.orange,
                  size: 12.0,
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
