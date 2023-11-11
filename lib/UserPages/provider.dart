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
