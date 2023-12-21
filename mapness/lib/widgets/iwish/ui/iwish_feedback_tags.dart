import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:mapness/entities/iwish/models/iwish_feedback_tag.dart';
import 'package:mapness/shared/config/package_config.dart';

class IwishFeedbackTags extends StatelessWidget {
  final List<IwishFeedbackTag> tags;
  final Set<String> selectedTags;
  final void Function(String id) onTagToggled;

  const IwishFeedbackTags({
    super.key,
    required this.tags,
    required this.selectedTags,
    required this.onTagToggled,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 4,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 78 / 90,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      children: tags
          .map(
            (e) => Material(
              color: Colors.transparent,
              child: Ink(
                decoration: BoxDecoration(
                  color: const Color(0xffF4F4F5),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: selectedTags.contains(e.id)
                        ? const Color(0xff4CA5B4)
                        : const Color(0xffF4F4F5),
                    width: 2,
                  ),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () => onTagToggled(e.id),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SvgPicture.asset(
                          e.assetUrl,
                          height: 24,
                          width: 24,
                          package: PackageConfig.packageName,
                          colorFilter: const ColorFilter.mode(
                            Color(0xff5E676F),
                            BlendMode.srcATop,
                          ),
                        ),
                        Text(
                          e.displayName,
                          textAlign: TextAlign.end,
                          style: Theme.of(context)
                              .extension<ThemeTextStyles>()!
                              .textS
                              .copyWith(color: const Color(0xFF1D2A36)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
