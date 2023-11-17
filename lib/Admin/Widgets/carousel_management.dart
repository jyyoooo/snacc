import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:snacc/Admin/Widgets/carousel.dart';
import 'package:snacc/Functions/image_picker.dart';
import 'package:snacc/UserPages/provider.dart';
import 'package:snacc/Widgets/snacc_appbar.dart';
import 'package:snacc/Widgets/snacc_button.dart';
import 'package:snacc/Widgets/snacc_textfield.dart';
import 'package:image_picker/image_picker.dart';

class CarouselManagement extends StatefulWidget {
  const CarouselManagement({Key? key}) : super(key: key);

  @override
  _CarouselManagementState createState() => _CarouselManagementState();
}

class _CarouselManagementState extends State<CarouselManagement> {
  String? _selectedImage;
  List<String>? carouselImages;

  @override
  void initState() {
    super.initState();
    _loadCarouselImages();
  }

  void _loadCarouselImages() {
    final carouselBox = Hive.box<String>('carousel');
    carouselImages = carouselBox.values.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        centerTitle: true,
        elevation: .4,
        backgroundColor: Colors.white,
        title: Text(
          'Carousel Management',
          style: GoogleFonts.nunitoSans(
            fontWeight: FontWeight.bold,
            fontSize: 23,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Carousel preview',
                    style: GoogleFonts.nunitoSans(
                        fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
            Card(
              clipBehavior: Clip.hardEdge,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              color: Colors.grey[100],
              child: SizedBox(
                width: double.infinity,
                height: 125,
                child: CarouselSlider.builder(
                  itemCount: carouselImages?.length ?? 0,
                  itemBuilder: (context, index, realIndex) {
                    if (carouselImages != null && carouselImages!.isNotEmpty) {
                      final imagePath = carouselImages![index];
                      return InkWell(
                        onLongPress: () {
                          _deleteImage(index);
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.file(
                            File(imagePath),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    } else {
                      return Image.asset(
                        'assets/images/no-image-available.png',
                        scale: 5,
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
                ),
              ),
            ),
            Text(
              'Tap and hold image to delete',
              style: GoogleFonts.nunitoSans(color: Colors.grey),
            ),
            const Gap(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Add to Carousel',
                    style: GoogleFonts.nunitoSans(
                        fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
            Text(
              'Ascpect ratio of 18:6 is recommended for offer card',
              style: GoogleFonts.nunitoSans(color: Colors.blue),
            ),
            const Gap(10),
            Card(
                clipBehavior: Clip.hardEdge,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                color: Colors.grey[100],
                child: SizedBox(
                  width: double.infinity,
                  height: 125,
                  child: _selectedImage == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/no-image-available.png',
                              scale: 5,
                            ),
                            Text(
                              'No image selected',
                              style: GoogleFonts.nunitoSans(color: Colors.grey),
                            )
                          ],
                        )
                      : Image.file(
                          File(
                            _selectedImage!,
                          ),
                          fit: BoxFit.cover,
                        ),
                )),
            const SizedBox(height: 10),
            SnaccButton(
              width: 80,
              btncolor: Colors.white,
              icon: const Icon(Icons.image, color: Colors.blue),
              inputText: '',
              callBack: () async {
                _selectedImage = await pickImageFromGallery();
                setState(() {});
              },
            ),
            const SizedBox(height: 20),
            SnaccButton(
              textColor: Colors.white,
              width: 170,
              inputText: 'ADD TO CAROUSEL',
              callBack: () {
                if (_selectedImage != null) {
                  final carouselBox = Hive.box<String>('carousel');
                  carouselBox.add(_selectedImage!);
                  _loadCarouselImages(); // Reload the images after adding a new one
                  setState(() {});
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _deleteImage(int index) {
    if (carouselImages != null && carouselImages!.isNotEmpty) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text(
                  'Delete image from carousel?',
                  style: GoogleFonts.nunitoSans(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                content: SizedBox(
                  width: 150,
                  height: 50,
                  child: _selectedImage != null
                      ? Image.file(File(_selectedImage!))
                      : null,
                ),
                actions: [
                  SnaccButton(
                      btncolor: Colors.red,
                      textColor: Colors.white,
                      inputText: 'DELETE',
                      callBack: () {
                        final carouselBox = Hive.box<String>('carousel');
                        carouselBox.deleteAt(index);
                        _loadCarouselImages();
                        setState(() {});
                        Navigator.pop(context);
                        Fluttertoast.showToast(
                            msg: 'Image deleted',
                            backgroundColor: Colors.amber);
                      })
                ],
              ));
    }
    
  }
}

// Provider.of<CarouselNotifier>(context, listen: false).updateCarousel();
