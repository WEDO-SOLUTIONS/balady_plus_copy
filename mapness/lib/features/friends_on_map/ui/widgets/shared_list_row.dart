import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/features/friends_on_map/models/shared_list.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

/// One row on `shared_lists_page.dart` — R-96's name + member count + entry
/// count.
class SharedListRow extends StatelessWidget {
  final SharedList list;
  final VoidCallback onTap;

  const SharedListRow({required this.list, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: Spacing.$2x, horizontal: Spacing.$4x),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  list.name,
                  overflow: TextOverflow.ellipsis,
                  style: context.textStyles.bodyLargeMedium.copyWith(color: context.colors.foregroundDefault),
                ),
                Text(
                  context.l10n.sharedListRowSubtitle(list.memberCount, list.itemCount),
                  style: context.textStyles.bodySmallRegular.copyWith(color: context.colors.foregroundMuted),
                ),
              ],
            ),
          ),
          Icon(SystemIcons.arrowCornerRightSmall, color: context.colors.foregroundMuted),
        ],
      ),
    ),
  );
}
