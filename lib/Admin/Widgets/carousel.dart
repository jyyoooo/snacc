import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class   SnaccCarousel extends StatelessWidget {
  final List<String> imageList = [
    'assets/images/offer1.jpeg',
    'assets/images/offer2.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SizedBox(
          height: 125,
          width: 400,
          child: CarouselSlider.builder(
            itemCount: imageList.length,
            itemBuilder: (context, index, realIndex) {
              final image = imageList[index];
              return ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  image,
                  fit: BoxFit.cover,
                ),
              );
            },
            options: CarouselOptions(
              initialPage: 1,
              // enlargeFactor: .3,
                autoPlay: true,
                autoPlayCurve: Curves.easeInOut,
                enlargeCenterPage: true,
                viewportFraction: 1,
                disableCenter: true,
                ),
          ),
        ),
      ),
    );
  }
}
