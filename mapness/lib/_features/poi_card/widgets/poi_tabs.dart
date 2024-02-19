import 'package:balady_uikit/colors/non_theme_colors.dart';
import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/poi_card/provider/poi_photo_provider.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/map/point_of_interest.dart';

class PoiTabs extends ConsumerStatefulWidget {
  final PoiModel model;
  final TabController tabController;

  const PoiTabs({
    required this.tabController,
    required this.model,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<PoiTabs> createState() => _PoiTabsState();
}

class _PoiTabsState extends ConsumerState<PoiTabs> {
  @override
  void initState() {
    super.initState();
    widget.tabController.addListener(() {
      if (widget.tabController.indexIsChanging) {
        if (!mounted) {
          return;
        }

        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final objectId = widget.model.directoryObjectMessage?.id?.objectId ?? 0;
    final photos = ref.watch(poiPhotoProvider(objectId));

    final count = photos.whenOrNull(
          data: (data) => data.items.length,
        ) ??
        0;

    return TabBar(
      padding: EdgeInsets.zero,
      controller: widget.tabController,
      indicatorColor: Colors.transparent,
      isScrollable: true,
      labelPadding: const EdgeInsetsDirectional.only(end: 2),
      tabs: [
        Tab(
          iconMargin: EdgeInsets.zero,
          child: _PoiTabItem(
            title: context.l10n.info,
            onTap: () => widget.tabController.animateTo(0),
            isActive: widget.tabController.index == 0,
          ),
        ),
        Tab(
          iconMargin: EdgeInsets.zero,
          child: _PoiTabItem(
            title: context.l10n.photos,
            count: count,
            onTap: () {
              if (count == 0) {
                widget.tabController.index = widget.tabController.previousIndex;
                return;
              }
              widget.tabController.animateTo(1);
            },
            isActive: widget.tabController.index == 1,
          ),
        ),
      ],
    );
  }
}

class _PoiTabItem extends StatelessWidget {
  final bool? isActive;
  final VoidCallback? onTap;
  final String title;
  final int? count;
  const _PoiTabItem(
      {required this.title, this.isActive, this.onTap, this.count});

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          boxShadow: isActive ?? false
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.07),
                    blurRadius: 1,
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        height: 36,
        child: Material(
          color: Colors.transparent,
          type: MaterialType.transparency,
          child: InkWell(
            borderRadius: BorderRadius.circular(6),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Center(
                child: Row(
                  children: [
                    Text(
                      title,
                      style: Theme.of(context)
                          .extension<ThemeTextStyles>()!
                          .accentS
                          .copyWith(
                            color: isActive ?? false
                                ? context.color.text_and_icons_base_primary
                                : context.color.text_and_icons_base_primary.withOpacity(0.5),
                          ),
                    ),
                    if (count != null)
                      Padding(
                        padding: const EdgeInsetsDirectional.only(
                          start: 6.0,
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            // Fix shape for big numbers
                            borderRadius:
                                count! < 100 ? null : BorderRadius.circular(50),
                            shape: count! < 100
                                ? BoxShape.circle
                                : BoxShape.rectangle,
                            color: isActive ?? false
                                ? context.color.stroke_accent
                                : NonThemeColor.color72.withOpacity(0.3),
                          ),
                          child: Text(
                            '$count',
                            style: Theme.of(context)
                                .extension<ThemeTextStyles>()!
                                .textXS
                                .copyWith(
                                  color: Colors.white,
                                ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
