import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mapness/entities/iwish/models/iwish_entity.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class IwishAboutPark extends StatelessWidget {
  final IwishMetadata metadata;
  final ParkSize parkSize;

  const IwishAboutPark({
    super.key,
    required this.metadata,
    required this.parkSize,
  });

  @override
  Widget build(BuildContext context) {
    final locale = context.l10n;
    final textStyles = Theme.of(context).extension<ThemeTextStyles>()!;
    final title = textStyles.textM;
    final data = textStyles.textS.copyWith(color: const Color(0xff8E949A));

    // switch (metadata.areaSize) {
    //   AreaSize.small => 'locale.small',
    //   AreaSize.medium => 'locale.medium',
    //   AreaSize.large => 'locale.large',
    // },
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ///
        Text(
          locale.aboutPark,
          style: textStyles.accentM,
        ),
        const SizedBox(height: 21),

        ///
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

        ///
        Text(
          locale.parkAreaSize,
          style: title,
        ),
        const SizedBox(height: 2),
        Text(
          NumberFormat('#,###').format(metadata.areaSize),
          style: data,
        ),
        const SizedBox(height: 22),

        ///
        Text(
          locale.parkOpeningDate,
          style: title,
        ),
        const SizedBox(height: 2),
        Text(
          DateFormat('dd.MM.yyyy').format(metadata.openingDate),
          style: data,
        ),
        const SizedBox(height: 22),

        ///
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
    );
  }
}
