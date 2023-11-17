import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mapness/entities/iwish/models/iwish_entity.dart';

class IwishStateLabel extends StatelessWidget {
  final IwishState state;

  const IwishStateLabel({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: switch (state) {
            IwishState.unknown => Colors.grey,
            IwishState.planned => const Color(0xFFFFB814),
            IwishState.completed => const Color(0xFF52B374),
          }),
      child: Text(
        switch (state) {
          IwishState.unknown => 'Unknown',
          IwishState.planned => 'Planned',
          IwishState.completed => 'Completed',
        },
        style: GoogleFonts.inter(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
