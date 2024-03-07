import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget infoWidget(String label, String title) {
  return Expanded(
    child: Container(
      margin: const EdgeInsets.all(16),
      constraints: const BoxConstraints.tightFor(),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.montserrat(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.grey[500],
            ),
          ),
          Text(
            title,
            style: GoogleFonts.montserrat(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    ),
  );
}
// }
