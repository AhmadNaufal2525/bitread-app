import 'package:bitread_app/screen/home/detail_news_event_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';

class Carousel extends StatefulWidget {
  const Carousel({super.key});

  @override
  CarouselState createState() => CarouselState();
}

class CarouselState extends State<Carousel> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection('NewsEvent').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              }

              List<QueryDocumentSnapshot> newsDocs = snapshot.data!.docs;
              List<Map<String, dynamic>> newsList = newsDocs.map((doc) {
                return {
                  'imageUrl': doc['imageUrl'] ?? '',
                  'namaEvent': doc['namaEvent'] ?? '',
                  'deskripsiEvent': doc['deskripsiEvent'] ?? '',
                  'author': doc['author'] ?? '',
                  'source': doc['source'] ?? '',
                  'tanggalUpload': (doc['tanggalUpload'] as Timestamp).toDate(),
                  'tipe': doc['tipe'] ?? ''
                };
              }).toList();
              return CarouselSlider(
                options: CarouselOptions(
                  height: 200.0,
                  enlargeCenterPage: true,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 10),
                  autoPlayAnimationDuration: const Duration(milliseconds: 1000),
                  autoPlayCurve: Curves.easeInOut,
                  pauseAutoPlayOnTouch: true,
                  aspectRatio: 16 / 9,
                  onPageChanged: (index, reason) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                ),
                items: newsList.map((entry) {
                  String image = entry['imageUrl'];
                  String title = entry['namaEvent'];
                  String uploadTime =
                      DateFormat('dd MMM yyyy').format(entry['tanggalUpload']);
                  return Builder(
                    builder: (BuildContext context) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NewsEventDetailScreen(
                                image: image,
                                title: title,
                                author: entry['author'],
                                description: entry['deskripsiEvent'],
                                sourceLink: entry['source'],
                                uploadTime: uploadTime,
                                tipe: entry['tipe']
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            image: DecorationImage(
                              image: NetworkImage(image),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.center,
                                colors: [
                                  Colors.black.withOpacity(1),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: Text(
                                  title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              );
            })
      ],
    );
  }
}
