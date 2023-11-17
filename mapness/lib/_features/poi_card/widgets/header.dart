import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mapness/_features/map/providers/point_of_interest.dart';
import 'package:mapness/_features/poi_card/widgets/style.dart';
import 'package:mapness/_features/poi_card/extensions/directory_object_ext.dart';
import 'package:mapness/shared/config/package_config.dart';

class PoiCardHeaderDelegate extends SliverPersistentHeaderDelegate {
  final PoiModel? data;
  final Function()? ontapClose;

  PoiCardHeaderDelegate({
    this.data,
    this.ontapClose,
  });

  @override
  Widget build(context, double shrinkOffset, bool overlapsContent) {
    return _Header(
      data: data,
      ontapClose: ontapClose,
    );
  }

  @override
  double get maxExtent => 132;

  @override
  double get minExtent => 124;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
}

class _Header extends StatelessWidget {
  final Function()? ontapClose;

  const _Header({
    required this.data,
    required this.ontapClose,
  });

  final PoiModel? data;

  @override
  Widget build(BuildContext context) {
    final address = data?.directoryObjectMessage?.address;
    final subTitle = data?.directoryObjectMessage?.makeAddress() ?? '';
    final title = address?.buildingName ?? data?.directoryObjectMessage?.title;

    final titleAddition = data?.directoryObjectMessage?.titleAddition ?? '';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        shadows: [
          BoxShadow(
            color: colorShadow,
            blurRadius: 22,
            offset: Offset(0, 4),
            spreadRadius: 0,
          )
        ],
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(
                              text: TextSpan(
                                  text: title,
                                  style: GoogleFonts.inter(
                                    color: colorPrimary,
                                    fontSize: 19,
                                    fontWeight: FontWeight.w700,
                                  )),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(
                              width: 40,
                            )
                          ],
                        ),
                        Text(
                          titleAddition,
                          style: GoogleFonts.inter(
                            color: colorPrimary.withOpacity(0.5),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: RichText(
                                text: TextSpan(
                                  text: subTitle,
                                  style: GoogleFonts.inter(
                                    color: colorPrimary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    height: 1.3,
                                  ),
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                textAlign: TextAlign.start,
                              ),
                            ),
                            buildBriefTime(data),
                          ],
                        ),
                      ],
                    ),
                  )
                ]),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: GestureDetector(
              onTap: ontapClose,
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(8),
                  ),
                  color: colorPrimary.withAlpha(10),
                ),
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(
                  "assets/icons/svg/ic_search_close.svg",
                  semanticsLabel: 'MinApps Screen',
                  package: "mapness",
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBriefTime(PoiModel? data) {
    final desc = data?.getBriefRouteDescription();
    return desc != null
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/icons/svg/ic_car_poi.svg',
                height: 16,
                width: 16,
                color: colorPrimary.withOpacity(0.5),
                package: PackageConfig.packageName,
                matchTextDirection: true,
              ),
              buildText(
                text: desc,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: colorPrimary.withOpacity(0.7),
              ),
            ],
          )
        : const SizedBox.shrink();
  }
}
