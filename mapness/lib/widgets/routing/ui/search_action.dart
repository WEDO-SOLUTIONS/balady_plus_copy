import 'package:balady_uikit/core/colors/non_theme_colors.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/shared/config/package_config.dart';

class SearchActions extends StatelessWidget {
  const SearchActions({
    required this.children,
    super.key,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListView.separated(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => children[index],
          separatorBuilder: (context, index) => const Padding(
            padding: EdgeInsets.only(right: 52),
            child: Divider(
              height: 1,
              thickness: 1,
              color: NonThemeColor.color53,
            ),
          ),
          itemCount: children.length,
        ),
      );
}

class SearchActionRow extends StatelessWidget {
  const SearchActionRow({
    required this.icon,
    required this.title,
    super.key,
  });

  final String icon;
  final String title;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 14,
                bottom: 10,
              ),
              child: SizedBox(
                width: 24,
                height: 24,
                child: SvgPicture.asset(
                  icon,
                  package: PackageConfig.packageName,
                  color: context.color.textAndIconsStatusAccent,
                ),
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 12,
                  bottom: 14,
                ),
                child: Text(
                  title,
                  style: context.textStyle.text.copyWith(color: context.color.textAndIconsBasePrimary),
                ),
              ),
            ),
          ],
        ),
      );
}
