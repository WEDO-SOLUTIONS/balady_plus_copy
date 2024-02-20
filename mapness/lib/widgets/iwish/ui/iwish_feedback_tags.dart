import 'package:auto_size_text/auto_size_text.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_uikit/colors/non_theme_colors.dart';
import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/entities/iwish/models/iwish_feedback_tag.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class IwishFeedbackTags extends StatelessWidget {
  final List<IwishFeedbackTag> tags;
  final Set<String> selectedTags;
  final void Function(String id) onTagToggled;
  final tagsGroup = AutoSizeGroup();

  IwishFeedbackTags({
    super.key,
    required this.tags,
    required this.selectedTags,
    required this.onTagToggled,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 3,
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
                  color: context.color.surface_base_primary,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: selectedTags.contains(e.id)
                        ? context.color.stroke_accent
                        : context.color.surface_base_primary,
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          e.assetUrl,
                          height: 24,
                          width: 24,
                          package: PackageConfig.packageName,
                          matchTextDirection: e.rtlAsset,
                          colorFilter: const ColorFilter.mode(
                            NonThemeColor.color63,
                            BlendMode.srcATop,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            alignment: context.isRTL
                                ? Alignment.bottomRight
                                : Alignment.bottomLeft,
                            width: double.infinity,
                            child: AutoSizeText(
                              e.displayName,
                              group: tagsGroup,
                              maxLines: 2,
                              wrapWords: false,
                              minFontSize: 8,
                              textAlign: context.isRTL
                                  ? TextAlign.right
                                  : TextAlign.left,
                              style: Theme.of(context)
                                  .extension<ThemeTextStyles>()!
                                  .textM
                                  .copyWith(
                                    color: context.color.text_and_icons_base_primary,
                                  ),
                            ),
                          ),
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
