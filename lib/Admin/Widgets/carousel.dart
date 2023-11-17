import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SnaccCarousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final carouselBox = Hive.box<String>('carousel');
    final ValueNotifier<List<String>> carouselNotifier =
        ValueNotifier(carouselBox.values.toList());

    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SizedBox(
          height: 125,
          width: double.infinity,
          child: ValueListenableBuilder<List<String>>(
            valueListenable: carouselNotifier,
            builder: (context, carouselImages, child) {
              return CarouselSlider.builder(
                itemCount: carouselImages.length,
                itemBuilder: (context, index, realIndex) {
                  if (index < carouselImages.length) {
                    final imagePath = carouselImages[index];
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.file(
                        File(imagePath),
                        fit: BoxFit.cover,
                      ),
                    );
                  } else {
                    // Placeholder image when no image is available
                    return Card(
                      color: Colors.grey[100],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: Image.asset(
                        'assets/images/no-image-available.png',
                        scale: 5,
                      ),
                    );
                  }
                },
                options: CarouselOptions(
                  initialPage: 1,
                  autoPlay: true,
                  autoPlayCurve: Curves.easeInOut,
                  enlargeCenterPage: true,
                  viewportFraction: 1,
                  disableCenter: true,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
