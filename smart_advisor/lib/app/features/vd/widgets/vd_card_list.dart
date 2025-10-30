import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/app/features/vd/widgets/vd_model.dart';

class VdCardList extends StatelessWidget {
  final VdModel items;
  const VdCardList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: 81,
          width: 102,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: const Color(0xFFF0F4F6)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Row(
                  children: [
                    Text(
                      items.titleone!,
                      style: GoogleFonts.cairo(
                          fontSize: 22, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Image.asset(
                      items.icons ?? "",
                      height: 10,
                      width: 10,
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 4,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(
                  items.subtitle!,
                  style: GoogleFonts.cairo(
                      fontSize: 12, color: const Color(0xFF37474F)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
