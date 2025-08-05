import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchActions extends StatelessWidget {
  const SearchActions({
    required this.children,
    super.key,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(RadiusBorder.xl),
        child: Material(
          color: context.colors.neutralContainerDefault,
          borderRadius: BorderRadius.circular(RadiusBorder.xl),
          child: ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(vertical: Spacing.$1x),
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => children[index],
            itemCount: children.length,
          ),
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
