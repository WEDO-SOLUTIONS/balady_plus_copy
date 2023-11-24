import 'package:flutter/material.dart';
import 'package:mapness/entities/path_nav/models/path_nav_eta.dart';
import 'package:mapness/shared/config/package_fonts.dart';

class PathNavContinueTrip extends StatelessWidget {
  final PathNavEta? eta;
  final VoidCallback onPressed;

  const PathNavContinueTrip({
    super.key,
    required this.onPressed,
    required this.eta,
  });

  Text _eta(String? text) => Text(
        text ?? '-',
        style: PackageFonts.frutigerArabic(
          color: Colors.white.withOpacity(0.800000011920929),
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xff4CA5B4),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Continue trip',
                style: PackageFonts.frutigerArabic(
                  color: Colors.white,
                  fontSize: 21,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _eta(eta?.arrivalTime),
                  const SizedBox(width: 4),
                  Container(
                    width: 2,
                    height: 2,
                    decoration: const ShapeDecoration(
                      color: Colors.white,
                      shape: OvalBorder(),
                    ),
                  ),
                  const SizedBox(width: 4),
                  _eta(eta?.distanceEta),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
