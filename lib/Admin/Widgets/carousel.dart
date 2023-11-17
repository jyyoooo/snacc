import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:snacc/UserPages/provider.dart';

class SnaccCarousel extends StatefulWidget {
  final List<String> carouselImages;

  const SnaccCarousel({Key? key, required this.carouselImages})
      : super(key: key);

  @override
  _SnaccCarouselState createState() => _SnaccCarouselState();
}

class _SnaccCarouselState extends State<SnaccCarousel> {
  late List<String> carouselImages;

  @override
  void initState() {
    super.initState();
    carouselImages = widget.carouselImages;
  }

  @override
  void didUpdateWidget(covariant SnaccCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.carouselImages != carouselImages) {
      setState(() {
        carouselImages = widget.carouselImages;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final carouselNotifier = Provider.of<CarouselNotifier>(context);

    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SizedBox(
          height: 125,
          width: double.infinity,
          child: carouselNotifier.carouselChanged
              ? carouselImages.isNotEmpty
                  ? CarouselSlider.builder(
                      itemCount: carouselImages.length,
                      itemBuilder: (context, index, realIndex) {
                        final imagePath = carouselImages[index];
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.file(
                            File(imagePath),
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                      options: CarouselOptions(
                        initialPage: 1,
                        autoPlay: true,
                        autoPlayCurve: Curves.easeInOut,
                        enlargeCenterPage: true,
                        viewportFraction: 1,
                        disableCenter: true,
                        onPageChanged: (index, reason) {},
                      ),
                    )
                  : Card(
                    color: Colors.grey[100],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: CarouselSlider(
                        items: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/no-image-available.png',
                                scale: 5,
                              ),
                              Text('No data',style: GoogleFonts.nunitoSans(color: Colors.grey),)
                            ],
                          ),
                        ],
                        options: CarouselOptions(
                          initialPage: 1,
                          autoPlay: true,
                          autoPlayCurve: Curves.easeInOut,
                          enlargeCenterPage: true,
                          viewportFraction: 1,
                          disableCenter: true,
                          onPageChanged: (index, reason) {},
                        ),
                      ),
                  )
              : Column(
                children: [
                  Image.asset(
                      'assets/images/no-image-available.png',
                      scale: 5,
                    ),
                    Text('Error',style: GoogleFonts.nunitoSans(),)
                ],
              ),
        ),
      ),
    );
  }
}
