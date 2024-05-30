import 'package:balady_uikit/core/typography/text_theme_styles.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mapness/_features/poi_card/extensions/directory_object_ext.dart';
import 'package:mapness/_features/poi_card/extensions/geopoint_mapper.dart';
import 'package:mapness/_features/poi_card/provider/poi_card_provider.dart';
import 'package:mapness/_features/poi_card/widgets/poi_tabs.dart';
import 'package:mapness/_features/poi_card/widgets/style.dart';
import 'package:mapness/entities/routing/route_search_point.dart';
import 'package:mapness/features/routing/ui/brief_route_widgets.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/map/point_of_interest.dart';

class PoiHeader extends ConsumerWidget {
  final PoiCardState? poiCardState;
  final TabController tabController;
  final DirectoryObjectMessage data;
  final Function()? onTapClose;

  const PoiHeader({
    required this.data,
    required this.onTapClose,
    required this.tabController,
    super.key,
    this.poiCardState,
  });

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
    final title = address?.buildingName ?? data.directoryObjectMessage?.title ?? '';
    final titleAddition = data.directoryObjectMessage?.titleAddition ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 6),
        _scrollHandle(),
        const SizedBox(height: 6),
        _title(context, title),
        _titleAddition(context, titleAddition),
        const SizedBox(height: 2),
        _subTitle(context, subTitle, data),
        const SizedBox(height: 6),
        PoiTabs(tabController: tabController, model: data, poiCardState: poiCardState),
      ],
    );
  }

  Widget _scrollHandle() => Center(
        child: Builder(
          builder: (context) => Container(
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              color: context.color.textAndIconsBasePrimary.withOpacity(0.1),
            ),
            height: 4,
            width: 40,
          ),
        ),
      );

  Widget _subTitle(BuildContext context, String text, PoiModel data) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              text,
              style: Theme.of(context)
                  .extension<ThemeTextStyles>()!
                  .footNote
                  .copyWith(color: context.color.textAndIconsBasePrimary),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              // textAlign: TextAlign.right,
            ),
          ),
          BriefRouteInfo(
            routeType: RouteSearchOptionsMessage.car,
            finishPoint: RouteSearchPoint(
              coordinates: this.data.markerPosition!.toGeoPointMessage(),
              dgisObjectId: this.data.id!,
            ),
          ),
        ],
      );

  Widget _title(BuildContext context, String text) {
    final titleTextStyle =
        Theme.of(context).extension<ThemeTextStyles>()!.heading1.copyWith(color: context.color.textAndIconsBasePrimary);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            text,
            style: titleTextStyle,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            textAlign: TextAlign.start,
          ),
        ),
        _buildcloseButton(),
      ],
    );
  }

  Widget _titleAddition(BuildContext context, String text) => text.isNotEmpty
      ? Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                text,
                style: Theme.of(context).extension<ThemeTextStyles>()!.footNote.copyWith(
                      color: context.color.textAndIconsBasePrimary.withOpacity(
                        0.5,
                      ),
                    ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                textAlign: TextAlign.start,
              ),
            ),
            const SizedBox(
              width: 56,
            ),
          ],
        )
      : const SizedBox.shrink();

  Widget _buildcloseButton() => Builder(
        builder: (context) => Padding(
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
                  color: context.color.textAndIconsBasePrimary.withAlpha(10),
                ),
                padding: const EdgeInsets.all(8),
                child: SvgPicture.asset(
                  'assets/icons/svg/ic_search_close.svg',
                  semanticsLabel: 'MinApps Screen',
                  package: PackageConfig.packageName,
                  colorFilter: ColorFilter.mode(
                    context.color.textAndIconsBasePrimary.withOpacity(0.7),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
