import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../navigation_dashboard/widgets/mapness_typography.dart';

class WorkingHours extends StatelessWidget {
  const WorkingHours({
    required this.hoursFrom,
    required this.hoursTo,
    required this.isOpen24x7,
    this.workingHoursDetails,
    this.showIcon = true,
    this.compact = false,
    super.key,
  });

  final String hoursFrom;
  final String hoursTo;
  final bool isOpen24x7;
  final String? workingHoursDetails;
  final bool showIcon;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isOpen24x7)
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (showIcon) ...[
                SvgPicture.asset(
                  "assets/svg/ic_time.svg",
                  width: 16,
                  height: 16,
                ),
                const SizedBox(width: 4),
              ],
              Text(
                compact ? hoursFrom : "From $hoursFrom",
                style: MapnessTypography.s,
              ),
              if (compact)
                Text(
                  " — ",
                  style: MapnessTypography.s,
                )
              else
                const SizedBox(width: 4),
              Text(
                compact ? hoursTo : "From $hoursTo",
                style: MapnessTypography.s,
              ),
              const Expanded(child: SizedBox(width: 4)),
            ],
          ),
        if (workingHoursDetails != null)
          Text(
            workingHoursDetails!,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w400,
              color: Color(0xff8e8e8e),
              fontSize: 15,
              height: 1.23,
            ),
          ),
      ],
    );
  }
}
