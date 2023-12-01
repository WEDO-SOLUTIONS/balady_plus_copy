import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter_svg/svg.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/map/point_of_interest.dart';
import 'package:mapness/_features/poi_card/widgets/style.dart';
import 'package:mapness/_features/poi_card/extensions/directory_object_ext.dart';
import 'package:mapness/shared/config/package_config.dart';

const mockArabickText =
    'الملك فهد، الرياضالملك فهد، الرياضالملك فهد، الرياض 12261، المملكة العربية السعودية الرياض';

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
      onTapClose: ontapClose,
    );
  }

  @override
  double get maxExtent => 150;

  @override
  double get minExtent => headerHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
}

class _Header extends StatelessWidget {
  final Function()? onTapClose;

  const _Header({
    required this.data,
    required this.onTapClose,
  });

  final PoiModel? data;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 16, right: 16),
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

      child: _buildContent(context, data),

      // child: Stack(
      //   children: [
      //     Align(
      //       alignment: Alignment.centerRight,
      //       child: _buildContent(context, data),
      //     ),
      //     Align(
      //       alignment: Alignment.topLeft,
      //       child: _buildcloseButton(),
      //     ),
      //   ],
      // ),
    );
  }

  Widget _buildContent(BuildContext context, PoiModel? data) {
    final address = data?.directoryObjectMessage?.address;
    final subTitle = data?.directoryObjectMessage?.makeAddress() ?? '';
    final title =
        address?.buildingName ?? data?.directoryObjectMessage?.title ?? '';
    final titleAddition = data?.directoryObjectMessage?.titleAddition ?? '';

    return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 6),
                _scrollHandle(),
                const SizedBox(height: 6),
                _title(context, title),
                _titleAddition(context, titleAddition),
                const SizedBox(height: 2),
                _subTitle(context, subTitle),
              ],
            ),
          )
        ]);
  }

  Widget _scrollHandle() {
    return Center(
        child: Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: colorPrimary.withOpacity(0.1),
      ),
      height: 4,
      width: 40,
    ));
  }

  Widget _subTitle(BuildContext context, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            text,
            style: Theme.of(context)
                .extension<ThemeTextStyles>()!
                .textS
                .copyWith(color: colorPrimary),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            textAlign: TextAlign.right,
          ),
        ),
        _buildBriefTime(context, data),
      ],
    );
  }

  Widget _title(BuildContext context, String text) {
    var titleTextStyle = Theme.of(context)
        .extension<ThemeTextStyles>()!
        .headingS
        .copyWith(color: colorPrimary);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            text,
            style: titleTextStyle,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            textAlign: TextAlign.start,
          ),
        ),
        _buildcloseButton(),
      ],
    );
  }

  Widget _titleAddition(BuildContext context, String text) {
    return text.isNotEmpty
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  text,
                  style: Theme.of(context)
                      .extension<ThemeTextStyles>()!
                      .textS
                      .copyWith(color: colorPrimary.withOpacity(0.5)),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  textAlign: TextAlign.start,
                ),
              ),
              const SizedBox(
                width: 56,
              )
            ],
          )
        : const SizedBox.shrink();
  }

  Widget _buildcloseButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Material(
        borderRadius: borderRadius,
        child: InkWell(
          borderRadius: borderRadius,
          onTap: onTapClose,
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
              color: colorPrimary.withOpacity(0.7),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBriefTime(BuildContext context, PoiModel? data) {
    final desc = data?.getBriefRouteDescription(context.l10n);
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
              const SizedBox(
                width: 4,
              ),
              Text(
                desc,
                style: Theme.of(context)
                    .extension<ThemeTextStyles>()!
                    .accentS
                    .copyWith(color: colorPrimary.withOpacity(0.7)),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                textAlign: TextAlign.right,
              )
            ],
          )
        : const SizedBox.shrink();
  }
}
