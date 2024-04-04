import 'package:balady_uikit/core/typography/text_theme_styles.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/make_address.dart';

class SuggestItem extends StatelessWidget {
  const SuggestItem({
    required this.suggest,
    required this.onTap,
    super.key,
  });

  final SuggestMessage suggest;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    var icon = '';
    String? address;
    if (suggest.handler.incompleteTextHandler != null) {
      icon = 'text';
    } else if (suggest.handler.objectHandler != null) {
      icon = 'object';
      address = suggest.handler.objectHandler!.item.makeAddress();
    } else if (suggest.handler.performSearchHandler != null) {
      icon = 'search';
    }

    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              SvgPicture.asset(
                'assets/icons/svg/ic_suggest_$icon.svg',
                package: PackageConfig.packageName,
                color: context.color.textAndIconsStatusAccent,
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(
                    start: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        overflow: TextOverflow.ellipsis,
                        TextSpan(
                          children: buildSuggestTitle(context, suggest),
                        ),
                      ),
                      if (address != null && address.isNotEmpty)
                        Text(
                          address,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .extension<ThemeTextStyles>()!
                              .text
                              .copyWith(
                                  color: context
                                      .color.textAndIconsBaseTertiary,),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Temporary solution without highlighting
List<TextSpan> buildSuggestTitle(BuildContext context, SuggestMessage suggest) {
  final prefixMapping = {
    ', region': 'منطقة',
    ', governorate': 'محافظة',
    ', city': 'مدينة',
    ', district area': 'محافظة',
    ', district': 'حى',
    ', street': 'شارع',
    ', buildings': 'مبنى',
    ', park': 'بارك',
  };
  var title = suggest.title.text;
  prefixMapping.forEach((key, replacement) {
    if (title.contains(key)) {
      title = "$replacement ${title.replaceAll(key, "")}";
    }
  });

  return [
    TextSpan(
      text: title,
      style: Theme.of(context)
          .extension<ThemeTextStyles>()!
          .text
          .copyWith(color: context.color.textAndIconsBasePrimary),
    ),
  ];
}
