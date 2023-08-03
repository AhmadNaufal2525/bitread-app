import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CardBookShimmer extends StatelessWidget {
  const CardBookShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Container(
                width: 160,
                height: 160,
                color: Colors.grey[300],
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12.0),
              Container(
                width: 100,
                height: 14,
                color: Colors.grey[300],
              ),
              const SizedBox(height: 8.0),
              Container(
                width: 100,
                height: 14,
                color: Colors.grey[300],
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
                  Container(
                    width: 40,
                    height: 12,
                    color: Colors.grey[300],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
