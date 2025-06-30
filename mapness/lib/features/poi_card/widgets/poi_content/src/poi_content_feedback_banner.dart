import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:mapness/features/poi_card/domain/model/poi_content/poi_content.dart';
import 'package:mapness/features/poi_card/extensions/poi_content/poi_content_ext.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class PoiContentFeedbackCard extends StatelessWidget {
  final PoiContentFeedbackType data;
  final void Function()? onTap;
  final EdgeInsetsGeometry padding;

  const PoiContentFeedbackCard({
    required this.data,
    this.padding = const EdgeInsets.symmetric(horizontal: Spacing.$4x),
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final foregroundColor = context.colorsV3.staticWhite;
    final titleStyle = context.textStyleV3.h4SemiBold.copyWith(color: foregroundColor);
    final subtitleStyle = context.textStyleV3.captionSmallMedium.copyWith(color: foregroundColor);

    const arrowPadding = EdgeInsetsDirectional.only(end: Spacing.$4x, bottom: Spacing.$4x);
    const contentPadding =
        EdgeInsetsDirectional.only(start: Spacing.$4x, top: Spacing.$4x - 1, bottom: Spacing.$4x - 1);

    return Padding(
      padding: padding,
      child: CupertinoButton(
        onPressed: onTap,
        padding: EdgeInsets.zero,
        minSize: 0,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(RadiusBorder.xl),
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: data.gradientColors),
            ),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: contentPadding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(data.title(context.l10n), style: titleStyle),
                          const SizedBox(height: Spacing.$1x),
                          Text(data.subtitle(context.l10n), style: subtitleStyle),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fitHeight,
                          matchTextDirection: true,
                          image: AssetImage(data.path),
                        ),
                      ),
                      child: const Align(
                        alignment: AlignmentDirectional.bottomEnd,
                        child: Padding(
                          padding: arrowPadding,
                          child: _ArrowIcon(),
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
}

class _ArrowIcon extends StatelessWidget {
  const _ArrowIcon();

  @override
  Widget build(BuildContext context) => SizedBox(
        width: Spacing.$6x,
        height: Spacing.$6x,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(RadiusBorder.s),
            color: context.colorsV3.staticWhite.withOpacity(0.2),
          ),
          child: Center(
            child: Icon(
              SystemIcons.arrowRight,
              color: context.colorsV3.staticWhite,
              size: Spacing.$5x,
            ),
          ),
        ),
      );
}
