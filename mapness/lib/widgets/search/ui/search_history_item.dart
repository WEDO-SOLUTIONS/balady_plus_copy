import 'package:balady_uikit/core/typography/text_theme_styles.dart';
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
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/icons/svg/ic_history.svg',
              colorFilter: ColorFilter.mode(
                context.color.textAndIconsStatusAccent,
                BlendMode.srcATop,
              ),
              package: PackageConfig.packageName,
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: result.address.isNotEmpty
                        ? EdgeInsets.zero
                        : const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      result.title,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .extension<ThemeTextStyles>()!
                          .text
                          .copyWith(
                              color: context.color.textAndIconsBasePrimary,),
                    ),
                  ),
                  if (result.address.isNotEmpty)
                    Text(
                      result.address,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .extension<ThemeTextStyles>()!
                          .text
                          .copyWith(
                              color:
                                  context.color.textAndIconsBaseTertiary,),
                    ),
                ],
              ),
            ),
          ],
        ),
      );
}
