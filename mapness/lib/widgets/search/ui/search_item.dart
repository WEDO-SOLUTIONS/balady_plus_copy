import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/make_address.dart';
import 'package:mapness/shared/config/package_fonts.dart';

class SearchItem extends StatelessWidget {
  const SearchItem({
    super.key,
    required this.result,
    required this.onTap,
  });

  final DirectoryObjectMessage result;
  final void Function() onTap;

  @override
  Widget build(
    BuildContext context,
  ) {
    String subtitle = result.subtitle;
    final prefixMapping = {
      "Region": "منطقة",
      "Governorate": "محافظة",
      "City": "مدينة",
      "District area": "محافظة",
      "District": "حى",
      "Street": "شارع",
      "Buildings": "مبنى",
      "Park": "بارك",
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
                style: PackageFonts.frutigerArabic(
                  fontSize: 16,
                  height: 1.4,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1E2A36),
                ),
              ),
              Row(
                children: [
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: PackageFonts.frutigerArabic(
                      fontSize: 16,
                      height: 1.4,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xB21E2A36),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  const Spacer(),
                  Text(
                    "1.3 ${context.l10n.km}",
                    overflow: TextOverflow.ellipsis,
                    style: PackageFonts.frutigerArabic(
                      fontSize: 16,
                      height: 1.4,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xB21E2A36),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                result.makeAddress(),
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
                style: PackageFonts.frutigerArabic(
                  fontSize: 16,
                  height: 1.4,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xB21E2A36),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
