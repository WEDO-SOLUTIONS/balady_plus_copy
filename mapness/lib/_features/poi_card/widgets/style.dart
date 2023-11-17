import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mapness/shared/config/package_config.dart';

const colorShadow = Color(0x1C77758D);
const colorPrimary = Color(0xff1E2A36);
const colorAccent = Color(0xff4CA5B4);
const colorIconPositive = Color(0xff52B374);
const colorIconError = Color(0xffD14733);

const footerHeight = 50.0;
const gapHeight = 16.0;

Widget buildText({
  String? text,
  int? maxLines,
  required double fontSize,
  required FontWeight fontWeight,
  required Color color,
}) {
  return text == null
      ? const SizedBox.shrink()
      : Text(
          text,
          style: GoogleFonts.inter(
            color: color,
            fontSize: fontSize,
            fontWeight: fontWeight,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: maxLines ?? 5,
          textAlign: TextAlign.start,
          // textDirection: TextDirection.ltr,
        );
}

BoxDecoration boxDecoration() => BoxDecoration(
  borderRadius: const BorderRadius.all(
    Radius.circular(8),
  ),
  color: colorPrimary.withAlpha(10),
);

Widget buildIconButton({
  required String assetName,
  String? desc,
  Function()? onTap,
}) {
  return Material(
    child: Container(
      height: 40,
      decoration: boxDecoration(),
      child: InkWell(
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
        ),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                key: ValueKey(assetName),
                assetName,
                height: 24,
                width: 24,
                package: PackageConfig.packageName,
                matchTextDirection: true,
              ),
              if (desc != null)
                buildText(
                  text: desc,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colorPrimary.withOpacity(0.5),
                ),
            ],
          ),
        ),
      ),
    ),
  );
}

SvgPicture timeIcon(Color color) => SvgPicture.asset(
      'assets/icons/svg/ic_time.svg',
      package: PackageConfig.packageName,
      height: 24,
      width: 24,
      color: color,
    );

SvgPicture parkingIcon = SvgPicture.asset(
  'assets/icons/svg/ic_parking_poi.svg',
  height: 24,
  width: 24,
  package: PackageConfig.packageName,
);
