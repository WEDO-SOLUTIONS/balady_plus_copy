import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart';
import 'package:mapness/widgets/routing/ui_kit/path_card/extensions/icon_from_type.dart';
import 'package:mapness/widgets/routing/ui_kit/path_card/extensions/priority_color.dart';
import 'package:mapness/widgets/routing/ui_kit/path_card/models/path_card_status.dart';

/// Icon and text in one line. Used in the path card.
class PathBadge extends StatelessWidget {
  final PathCardStatus info;
  const PathBadge(this.info, {super.key});

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            info.type.icon(context),
            color: info.priority.iconColor(context),
            size: 16,
          ),
          Spacing.$1x.widthBox,
          Text(
            info.text,
            style: context.textStyles.captionMediumRegular.copyWith(
              color: info.priority.textColor(context),
            ),
          ),
        ],
      );
}
