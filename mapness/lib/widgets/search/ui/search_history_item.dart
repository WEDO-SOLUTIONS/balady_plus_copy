import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/entities/search/models/search_history.dart' as models;
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/config/package_fonts.dart';

class SearchHistoryItem extends StatelessWidget {
  const SearchHistoryItem({
    super.key,
    required this.result,
  });

  final models.SearchHistoryItem result;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          SvgPicture.asset(
            "assets/icons/svg/ic_history.svg",
            package: PackageConfig.packageName,
          ),
          const SizedBox(
            width: 12,
          ),
          Expanded(
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
                if (result.address.isNotEmpty)
                  Text(
                    result.address,
                    overflow: TextOverflow.ellipsis,
                    style: PackageFonts.frutigerArabic(
                      fontSize: 16,
                      height: 1.4,
                      fontWeight: FontWeight.w400,
                      color: const Color(0x801E2A36),
                    ),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
