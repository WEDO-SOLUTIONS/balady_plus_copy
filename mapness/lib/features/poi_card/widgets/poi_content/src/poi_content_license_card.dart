import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/features/poi_card/domain/model/poi_content/poi_content.dart';
import 'package:mapness/shared/utils/copy_to_clipboard.dart';

class PoiContentLicenseCard extends StatelessWidget {
  final PoiContentLicenseModel? license;
  final EdgeInsets padding;
  const PoiContentLicenseCard({
    required this.license,
    this.padding = const EdgeInsets.symmetric(horizontal: Spacing.$4x),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (license == null) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: padding,
      child: Row(
        children: [
          Text(
            license!.title,
            style: context.textStyles.captionLargeRegular.copyWith(
              color: context.colors.foregroundSoft,
            ),
          ),
          const SizedBox(width: Spacing.$1x),
          SelectableText(
            license!.number,
            style: context.textStyles.captionLargeRegular.copyWith(
              color: context.colors.foregroundSoft,
            ),
            onTap: () => onCopyToClipboard(license!.number),
          ),
        ],
      ),
    );
  }
}
