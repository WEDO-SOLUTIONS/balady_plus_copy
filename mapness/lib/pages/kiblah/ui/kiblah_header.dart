import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/config/package_fonts.dart';

class KiblahHeader extends StatelessWidget {
  const KiblahHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 12,
        left: 12,
        right: 12,
      ),
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.loose,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.07),
                    spreadRadius: 0,
                    blurRadius: 1,
                    offset: const Offset(0, 0),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    spreadRadius: 0,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
              child: Material(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    context.pop();
                  },
                  child: Container(
                    constraints: const BoxConstraints(minWidth: 48),
                    height: 48,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/svg/ic_chevron_right.svg',
                          height: 24,
                          width: 24,
                          package: PackageConfig.packageName,
                          colorFilter: const ColorFilter.mode(
                            Color(0xFF1E2A36),
                            BlendMode.srcIn,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Text(
            "121º القبلة",
            style: PackageFonts.frutigerArabic(
              color: Colors.white,
              fontWeight: FontWeight.w400,
              fontSize: 18,
              height: 1.5,
            ),
          )
        ],
      ),
    );
  }
}
