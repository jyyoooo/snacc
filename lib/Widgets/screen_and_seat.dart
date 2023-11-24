import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:snacc/UserPages/provider.dart';
import 'package:snacc/Widgets/seat_selector.dart';

class ScreenAndSeat extends StatefulWidget {
  const ScreenAndSeat({super.key});

  @override
  State<ScreenAndSeat> createState() => _ScreenAndSeatState();
}

class _ScreenAndSeatState extends State<ScreenAndSeat> {
  @override
  Widget build(BuildContext context) {
    var seatScreenData = Provider.of<SeatScreenData>(context);

    return Card(
      color: Colors.red.withOpacity(.1),
      elevation: 0,
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () {
          showModalBottomSheet(
            backgroundColor: Colors.grey[100],
            constraints: const BoxConstraints.expand(),
            useSafeArea: true,
            isScrollControlled: true,
            showDragHandle: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            context: context,
            builder: (context) {
              return TheaterSeatPicker(
                onSeatSelected: (screen, seat) {
                  seatScreenData.updateData(seat, screen);
                },
              );
            },
          );
        },
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(40, 15, 40, 15),
              child: Column(
                children: [
                  Text(
                    'YOUR SEAT',
                    style: GoogleFonts.nunitoSans(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Colors.white),
                  ),
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: seatScreenData.selectedScreenNumber == null ||
                              seatScreenData.selectedScreenNumber == 0
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.chair_outlined,color: Colors.blueAccent,),
                                const Gap(10),
                                Text('Screen and Seat',
                                    style: GoogleFonts.nunitoSans(
                                        color: Colors.blueAccent,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 18))
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Screen',
                                  style: GoogleFonts.nunitoSans(
                                      fontSize: 23,
                                      fontWeight: FontWeight.normal),
                                ),
                                const Gap(10),
                                Text(
                                    seatScreenData.selectedScreenNumber
                                            ?.toString() ??
                                        '',
                                    style: GoogleFonts.nunitoSans(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue)),
                                const Gap(20),
                                Text('Seat',
                                    style: GoogleFonts.nunitoSans(
                                        fontSize: 23,
                                        fontWeight: FontWeight.normal)),
                                const Gap(10),
                                Text(seatScreenData.selectedSeatNumber ?? '',
                                    style: GoogleFonts.nunitoSans(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue)),
                              ],
                            ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
