import 'package:balady_uikit/core/colors/non_theme_colors.dart';
import 'package:balady_uikit/core/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mapness/entities/iwish/models/iwish_entity.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/utils/text_utils/arabic_numerals.dart';

class IwishAboutPark extends StatelessWidget {
  const IwishAboutPark({
    required this.metadata,
    required this.parkSize,
    super.key,
  });
  final IwishMetadata metadata;
  final ParkSize parkSize;

  @override
  Widget build(BuildContext context) {
    final locale = context.l10n;
    final textStyles = Theme.of(context).extension<ThemeTextStyles>()!;
    final title = textStyles.text;
    final data = textStyles.footNote.copyWith(color: NonThemeColor.color16);

    final showSize = parkSize != ParkSize.unknown;
    final showArea = metadata.areaSize != 0;
    final showOpeningDate = metadata.openingDate != DateTime.fromMillisecondsSinceEpoch(0);
    final showAmanah = metadata.areaName != '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ///
        Text(
          locale.aboutPark,
          style: textStyles.callout,
        ),
        const SizedBox(height: 21),

        ///
        if (showSize) ...[
          Text(
            locale.parkType,
            style: title,
          ),
          const SizedBox(height: 2),
          Text(
            switch (parkSize) {
              ParkSize.small => locale.parkSizeSmall,
              ParkSize.medium => locale.parkSizeMedium,
              ParkSize.large => locale.parkSizeBig,
              ParkSize.unknown => locale.parkSizeUnknown,
            },
            style: data,
          ),
          const SizedBox(height: 22),
        ],

        ///
        if (showArea) ...[
          Text(
            locale.parkAreaSize,
            style: title,
          ),
          const SizedBox(height: 2),
          Text(
            locale.digits(NumberFormat('#,###').format(metadata.areaSize)),
            style: data,
          ),
          const SizedBox(height: 22),
        ],

        ///
        if (showOpeningDate) ...[
          Text(
            locale.parkOpeningDate,
            style: title,
          ),
          const SizedBox(height: 2),
          Text(
            locale.digits(DateFormat('dd.MM.yyyy').format(metadata.openingDate)),
            style: data,
          ),
          const SizedBox(height: 22),
        ],

        ///
        if (showAmanah) ...[
          Text(
            locale.parkAmanah,
            style: title,
          ),
          const SizedBox(height: 2),
          Text(
            metadata.areaName,
            style: data,
          ),
        ],
      ],
    );
  }
}
