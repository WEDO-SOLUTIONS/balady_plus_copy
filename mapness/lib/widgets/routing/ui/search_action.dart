import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/shared/config/package_config.dart';

import '../../../shared/config/package_fonts.dart';

class SearchActions extends StatelessWidget {
  const SearchActions({
    super.key,
    required this.children,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
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
            color: Color(0x261E2A36),
          ),
        ),
        itemCount: children.length,
      ),
    );
  }
}

class SearchActionRow extends StatelessWidget {
  const SearchActionRow({
    super.key,
    required this.icon,
    required this.title,
  });

  final String icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                style: PackageFonts.frutigerArabic(
                  color: const Color(0xFF1E2A36),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
