import 'package:balady_uikit/core/typography/text_theme_styles.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/make_address.dart';

class SearchItem extends StatelessWidget {
  const SearchItem({
    required this.result, required this.onTap, super.key,
  });

  final DirectoryObjectMessage result;
  final void Function() onTap;

  @override
  Widget build(
    BuildContext context,
  ) {
    var subtitle = result.subtitle;
    final prefixMapping = {
      'Region': 'منطقة',
      'Governorate': 'محافظة',
      'City': 'مدينة',
      'District area': 'محافظة',
      'District': 'حى',
      'Street': 'شارع',
      'Buildings': 'مبنى',
      'Park': 'بارك',
    };
    if (prefixMapping.containsKey(subtitle)) {
      subtitle = prefixMapping[subtitle]!;
    }

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                result.title,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .extension<ThemeTextStyles>()!
                    .text
                    .copyWith(color: context.color.textAndIconsBasePrimary),
              ),
              Row(
                children: [
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .extension<ThemeTextStyles>()!
                        .text
                        .copyWith(color: context.color.textAndIconsBasePrimary),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  const Spacer(),
                  // Text(
                  //   "1.3 ${context.l10n.km}",
                  //   overflow: TextOverflow.ellipsis,
                  //   style: Theme.of(context).extension<ThemeTextStyles>()!.text.copyWith(color: context.color.textAndIconsBasePrimary),
                  // ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                result.makeAddress(),
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .extension<ThemeTextStyles>()!
                    .text
                    .copyWith(color: context.color.textAndIconsBasePrimary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
