import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HistoryCard extends StatelessWidget {
  const HistoryCard({
    super.key,
    required this.temp,
    required this.day,
    required this.cardColor,
    required this.icon,
  });

  final String temp;
  final String day;
  final Color cardColor;
  final String icon;

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: cardColor,
      ),
      alignment: Alignment.center,
      margin: EdgeInsets.only(bottom: screenHeight * 0.001), // Relative spacing
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            day,
            style: GoogleFonts.rubik(
              color: Colors.white,
              fontWeight: FontWeight.normal,
              letterSpacing: 2,
            ),
          ),
          Image.asset(
            icon,
            width: 50,
            height: 40,
          ),
          Text(
            temp,
            style: GoogleFonts.rubik(
              color: Colors.white,
              fontWeight: FontWeight.normal,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }
}
