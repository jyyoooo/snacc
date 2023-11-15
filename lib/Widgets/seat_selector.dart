import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:snacc/UserPages/provider.dart';
import 'package:snacc/Widgets/snacc_button.dart';

enum SeatState { unselected, selected }

class TheaterSeatPicker extends StatefulWidget {
  final void Function(int screen, String seat) onSeatSelected;

  const TheaterSeatPicker({Key? key, required this.onSeatSelected})
      : super(key: key);
  @override
  TheaterSeatPickerState createState() => TheaterSeatPickerState();
}

class TheaterSeatPickerState extends State<TheaterSeatPicker> {
  String? seatNumber;
  int? screenNumber;
  int rowCount = 8;
  int colCount = 8;

  List<List<SeatState>> seats = List.generate(
    8,
    (row) => List.generate(
      8,
      (col) => SeatState.unselected,
    ),
  );

  int selectedRowIndex = -1;
  int selectedColIndex = -1;

  @override
  Widget build(BuildContext context) {
    var seatScreenData = context.read<SeatScreenData>();
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Text(
                'Select Screen and Seat',
                style: GoogleFonts.nunitoSans(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  HorizontalNumberList(
                    onScreenSelected: (screen) {
                      setState(() {
                        screenNumber = screen;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          SvgPicture.asset('assets/images/theater_items/screen.svg'),
          Text(
            'Eyes this way',
            style: GoogleFonts.nunitoSans(fontSize: 15, color: Colors.blue),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 30,
                height: 320,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    rowCount,
                    (index) => Text(
                        String.fromCharCode('A'.codeUnitAt(0) + index),
                        style: GoogleFonts.nunitoSans(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 320,
                  height: 350,
                  child: GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: colCount,
                      mainAxisExtent: 42,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 1,
                    ),
                    itemBuilder: (context, index) {
                      int rowIndex = index ~/ colCount;
                      int colIndex = index % colCount;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (selectedRowIndex != -1 &&
                                selectedColIndex != -1) {
                              seats[selectedRowIndex][selectedColIndex] =
                                  SeatState.unselected;
                            }
                            seats[rowIndex][colIndex] = seats[rowIndex]
                                        [colIndex] ==
                                    SeatState.unselected
                                ? SeatState.selected
                                : SeatState.unselected;
                            selectedRowIndex = rowIndex;
                            selectedColIndex = colIndex;
                          });
                        },
                        child: Container(
                          child: seats[rowIndex][colIndex] ==
                                  SeatState.unselected
                              ? SvgPicture.asset(
                                  'assets/images/theater_items/unselected.svg',
                                  height: 30,
                                  width: 30,
                                )
                              : SvgPicture.asset(
                                  'assets/images/theater_items/selected.svg',
                                  color: const Color.fromARGB(255, 82, 211, 86),
                                  height: 30,
                                  width: 30,
                                ),
                        ),
                      );
                    },
                    itemCount: rowCount * colCount,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(50, 0, 25, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                colCount,
                (index) => Text(
                  (index + 1).toString(),
                  style: GoogleFonts.nunitoSans(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          const Gap(15),
          Text(
            seatScreenData.selectedScreenNumber != null &&
                    seatScreenData.selectedSeatNumber != null
                ? 'Your Screen: ${seatScreenData.selectedScreenNumber ?? '?'} Seat: ${seatScreenData.selectedSeatNumber}'
                : selectedRowIndex != -1 && selectedColIndex != -1 ||
                        screenNumber == 0
                    ? 'Your Screen: $screenNumber Seat: ${String.fromCharCode('A'.codeUnitAt(0) + selectedRowIndex)}${selectedColIndex + 1}'
                    : 'Your Seat and Screen is not selected',
            style: GoogleFonts.nunitoSans(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
          const Gap(10),
          SnaccButton(
            width: 100,
            inputText: 'DONE',
            callBack: () {
              if (selectedRowIndex != -1 && selectedColIndex != -1) {
                seatNumber =
                    '${String.fromCharCode('A'.codeUnitAt(0) + selectedRowIndex)}${selectedColIndex + 1}';
                widget.onSeatSelected(screenNumber ?? 0, seatNumber!);
              } else {
                log('no screen or seat selected');
              }
              Navigator.pop(context);
            },
            textColor: Colors.white,
          ),
        ],
      ),
    );
  }
}

class HorizontalNumberList extends StatefulWidget {
  void Function(int selectedNumber) onScreenSelected;

  HorizontalNumberList({Key? key, required this.onScreenSelected})
      : super(key: key);
  @override
  HorizontalNumberListState createState() => HorizontalNumberListState();
}

class HorizontalNumberListState extends State<HorizontalNumberList> {
  int selectedNumber = -1;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 2,
        itemBuilder: (context, index) {
          int number = index + 1;
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedNumber = number;
                log('tapped screen: $selectedNumber');
                widget.onScreenSelected(selectedNumber);
              });
            },
            child: Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: selectedNumber == number
                    ? const Color.fromARGB(255, 82, 211, 86)
                    : Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$number',
                style: GoogleFonts.nunitoSans(
                  color: selectedNumber == number ? Colors.white : Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
