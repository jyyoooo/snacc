import 'dart:developer';

import 'package:flutter/material.dart';

class SeatScreenData extends ChangeNotifier {
  String? selectedSeatNumber;
  int? selectedScreenNumber;

  void updateData(String seat, int screen) {
    selectedSeatNumber = seat;
    selectedScreenNumber = screen;
    notifyListeners();
  }
}


class CarouselNotifier extends ChangeNotifier {
  bool _carouselChanged = false;

  bool get carouselChanged => _carouselChanged;

  void updateCarousel() {
    log('CarouselNotifier: Updating carousel');
    _carouselChanged = true;
    notifyListeners();
  }
}