import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/widgets.dart';
import 'package:mapness/features/poi_card/domain/model/poi_content/poi_content.dart';

class PoiContentDataIncorrectCard extends StatelessWidget {
  final PoiContentDataIncorrectModel data;
  const PoiContentDataIncorrectCard({
    required this.data,
    super.key,
  });

  @override
  Widget build(BuildContext context) => ContentWrapper(
        children: [
          ContentRowV2(
            onTap: data.onFeedbackTap,
            leading: AppIcons(
              iconData: GeneralIcons.warning,
              color: context.colorsV3.accentDefault,
            ),
            text: ContentRowTextOptions(
              title: data.title,
            ),
            trailing: ContentRowTextTrailingOptions(
              icon: SystemIcons.arrowCornerRightSmall,
              iconColor: context.colorsV3.foregroundMuted,
            ),
          ),
        ],
      );
}
