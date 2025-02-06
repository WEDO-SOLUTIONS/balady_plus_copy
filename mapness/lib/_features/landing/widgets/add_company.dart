import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class AddCompanyBanner extends StatelessWidget {
  const AddCompanyBanner({super.key});

  @override
  Widget build(BuildContext context) {
    /// It's normal that some components are not from the design and color system too
    final colors = [
      const Color(0xFF9F6AD7),
      const Color(0xFF7035AF),
    ];
    const padding = EdgeInsets.symmetric(
      horizontal: Spacing.$4x,
      vertical: Spacing.$3x,
    );
    const imagePath = 'packages/mapness/assets/images/add_company.png';

    return GestureDetector(
      onTap: () {
        context.router.push(
          FeedbackRoute(
            poiId: 0,
            categoryId: 'add_company',
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(RadiusBorder.xl),
          gradient: LinearGradient(
            colors: colors,
            begin: const Alignment(-0.6, -1.0),
            end: const Alignment(1.0, 0.6),
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              child: Align(
                alignment: Alignment.centerRight,
                child: Image.asset(
                  imagePath,
                  width: 131,
                ),
              ),
            ),
            Padding(
              padding: padding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.addPlace,
                    style: context.textStyleV3.h4SemiBold.copyWith(color: context.colorsV3.staticWhite),
                  ),
                  const SizedBox(height: Spacing.$1x),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 200,
                        child: Text(
                          context.l10n.addInformationAboutCompany,
                          style: context.textStyleV3.captionSmallMedium.copyWith(color: context.colorsV3.staticWhite),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(RadiusBorder.s),
                        ),
                        padding: const EdgeInsets.all(Spacing.$0_5x),
                        child: Center(child: Icon(SystemIcons.arrowRight, color: context.colorsV3.staticWhite)),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
