import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/shared/lib/make_address.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/config/package_fonts.dart';
// import 'package:mapness/widgets/search/lib/build_suggest_title.dart';

class SuggestItem extends StatelessWidget {
  const SuggestItem({
    super.key,
    required this.suggest,
    required this.onTap,
  });

  final SuggestMessage suggest;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    String icon = "";
    String? address;
    if (suggest.handler.incompleteTextHandler != null) {
      icon = "text";
    } else if (suggest.handler.objectHandler != null) {
      icon = "object";
      address = suggest.handler.objectHandler!.item.makeAddress();
    } else if (suggest.handler.performSearchHandler != null) {
      icon = "search";
    }

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            SvgPicture.asset(
              "assets/icons/svg/ic_suggest_$icon.svg",
              package: PackageConfig.packageName,
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      overflow: TextOverflow.ellipsis,
                      TextSpan(
                        children: buildSuggestTitle(suggest),
                      ),
                    ),
                    if (address != null && address.isNotEmpty)
                      Text(
                        address,
                        overflow: TextOverflow.ellipsis,
                        style: PackageFonts.frutigerArabic(
                          fontSize: 16,
                          height: 1.4,
                          fontWeight: FontWeight.w500,
                          color: const Color(0x801E2A36),
                        ),
                      ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// Temporary solution without highlighting
List<TextSpan> buildSuggestTitle(suggest) {
  final prefixMapping = {
    ", region": "منطقة",
    ", governorate": "محافظة",
    ", city": "مدينة",
    ", district area": "محافظة",
    ", district": "حى",
    ", street": "شارع",
    ", buildings": "مبنى",
    ", park": "بارك",
  };
  String title = suggest.title.text;
  prefixMapping.forEach((key, replacement) {
    if (title.contains(key)) {
      title = "$replacement ${title.replaceAll(key, "")}";
    }
  });

  return [
    TextSpan(
      text: title,
      style: PackageFonts.frutigerArabic(
        fontSize: 16,
        height: 1.4,
        fontWeight: FontWeight.w500,
        color: const Color(0x801E2A36),
      ),
    )
  ];
}
