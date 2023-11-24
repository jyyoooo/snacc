import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void showSnaccBar(scaffoldContext, String content, Color color) {
  ScaffoldMessenger.of(scaffoldContext).showSnackBar(
    SnackBar(
      dismissDirection: DismissDirection.none,
      duration: const Duration(seconds: 4),
      showCloseIcon: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      behavior: SnackBarBehavior.floating,
      backgroundColor: color,
      content: Text(
        content,
        style: GoogleFonts.nunitoSans(),
      ),
    ),
  );
}
