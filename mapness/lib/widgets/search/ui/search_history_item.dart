import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/entities/search/models/search_history.dart' as models;
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class SearchHistoryItem extends StatelessWidget {
  const SearchHistoryItem({
    required this.result,
    super.key,
  });

  final models.SearchHistoryItem result;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: ContentRow(
          options: ContentRowOptions(
            padding: EdgeInsets.zero,
            leadingIcon: SvgPicture.asset(
              'assets/icons/svg/ic_history.svg',
              color: context.color.textAndIconsBaseTertiary,
              package: PackageConfig.packageName,
            ),
            title: result.title,
            subtitle: result.address,
          ),
        ),
      );
}
