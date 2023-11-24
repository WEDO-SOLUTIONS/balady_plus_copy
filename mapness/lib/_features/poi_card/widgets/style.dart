import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/config/package_fonts.dart';

const colorShadow = Color(0x1C77758D);
const colorPrimary = Color(0xff1E2A36);
const colorAccent = Color(0xff4CA5B4);
const colorIconPositive = Color(0xff52B374);
const colorIconError = Color(0xffD14733);

const headerHeight = 124.0;
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
          style: PackageFonts.frutigerArabic(
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

const borderRadius = BorderRadius.all(
  Radius.circular(8),
);

BoxDecoration boxDecoration() => const BoxDecoration(
      borderRadius: borderRadius,
    );

Widget buildIconButton({
  required String assetName,
  Widget? desc,
  Function()? onTap,
  Color? colorIcon,
  Color? colorButton,
  int flex = 1,
}) {
  return Flexible(
    flex: flex,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Material(
        color: colorButton ?? colorPrimary.withOpacity(0.05),
        borderRadius: borderRadius,
        child: InkWell(
          borderRadius: borderRadius,
          onTap: onTap,
          child: Container(
            constraints: const BoxConstraints(
              minHeight: 40,
              maxHeight: 40,
              minWidth: 52,
            ),
            decoration: boxDecoration(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    key: ValueKey(assetName),
                    assetName,
                    height: 24,
                    width: 24,
                    color: colorIcon,
                    package: PackageConfig.packageName,
                    matchTextDirection: true,
                  ),
                  if (desc != null) ...[
                    const SizedBox(
                      width: 8,
                    ),
                    desc,
                  ]
                ],
              ),
            ),
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
