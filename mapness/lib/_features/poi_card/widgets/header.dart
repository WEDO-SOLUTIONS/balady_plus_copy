import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mapness/_features/poi_card/extensions/geopoint_mapper.dart';
import 'package:mapness/features/routing/ui/brief_route_widgets.dart';
import 'package:mapness/shared/providers/map/point_of_interest.dart';
import 'package:mapness/_features/poi_card/widgets/style.dart';
import 'package:mapness/_features/poi_card/extensions/directory_object_ext.dart';

const mockArabickText =
    'الملك فهد، الرياضالملك فهد، الرياضالملك فهد، الرياض 12261، المملكة العربية السعودية الرياض';

class PoiCardHeaderDelegate extends SliverPersistentHeaderDelegate {
  final DirectoryObjectMessage data;
  final Function()? ontapClose;

  PoiCardHeaderDelegate({
    required this.data,
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

class _Header extends ConsumerWidget {
  final Function()? onTapClose;

  const _Header({
    required this.data,
    required this.onTapClose,
  });

  final DirectoryObjectMessage data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = PoiModel(
      directoryObjectMessage: data,
    );

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

      child: _buildContent(context, model),

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

  Widget _buildContent(BuildContext context, PoiModel data) {
    final address = data.directoryObjectMessage?.address;
    final subTitle = data.directoryObjectMessage?.makeAddress() ?? '';
    final title =
        address?.buildingName ?? data.directoryObjectMessage?.title ?? '';
    final titleAddition = data.directoryObjectMessage?.titleAddition ?? '';

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
                _subTitle(context, subTitle, data),
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

  Widget _subTitle(BuildContext context, String text, PoiModel data) {
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
        BriefRouteInfo(
          routeType: RouteSearchOptionsMessage.car,
          finishPoint: RouteSearchPointMessage(
            coordinates: this.data.markerPosition!.toGeoPointMessage(),
            objectId: this.data.id!,
          ),
        ),
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
}
