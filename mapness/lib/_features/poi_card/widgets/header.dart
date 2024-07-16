import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/_features/poi_card/provider/poi_card_provider.dart';
import 'package:mapness/_features/poi_card/widgets/poi_tabs.dart';
import 'package:mapness/_features/poi_card/widgets/style.dart';
import 'package:mapness/shared/config/package_config.dart';
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
    final address = model.directoryObjectMessage?.address;
    final subTitle = model.directoryObjectMessage?.subtitle ?? '';
    final title = address?.buildingName ?? model.directoryObjectMessage?.title ?? '';

    final titleTextStyle = context.textStyle.heading1.copyWith(
      color: context.color.textAndIconsBasePrimary,
    );
    final subTitleTextStyle = context.textStyle.footNote.copyWith(
      color: context.color.textAndIconsBaseSecondary,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 6),
          const Center(child: SheetDragger()),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: titleTextStyle,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      textAlign: TextAlign.start,
                    ),
                    _SubTitle(
                      subTitle: subTitle,
                      subTitleTextStyle: subTitleTextStyle,
                      tabController: tabController,
                    ),
                  ],
                ),
              ),
              Builder(
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
              ),
            ],
          ),
          const SizedBox(height: 6),
          PoiTabs(
            tabController: tabController,
            model: model,
            poiCardState: poiCardState,
          ),
        ],
      ),
    );
  }
}

class _SubTitle extends StatefulWidget {
  const _SubTitle({
    required this.subTitle,
    required this.subTitleTextStyle,
    required this.tabController,
    Key? key,
  }) : super(key: key);

  final String subTitle;
  final TextStyle subTitleTextStyle;
  final TabController tabController;

  @override
  State<_SubTitle> createState() => _SubTitleState();
}

class _SubTitleState extends State<_SubTitle> {
  var _isShowSubTitle = true;

  @override
  void initState() {
    super.initState();
    widget.tabController.addListener(() {
      if (!widget.tabController.indexIsChanging) {
        setState(() {
          _isShowSubTitle = widget.tabController.index == 0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) => AnimatedOpacity(
        duration: const Duration(milliseconds: 250),
        opacity: _isShowSubTitle ? 1 : 0,
        child: Text(
          widget.subTitle,
          style: widget.subTitleTextStyle,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          textAlign: TextAlign.start,
        ),
      );
}
