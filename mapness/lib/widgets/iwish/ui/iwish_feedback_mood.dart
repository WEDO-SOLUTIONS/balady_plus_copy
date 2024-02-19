import 'package:balady_uikit/colors/non_theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class IwishFeedbackMood extends StatelessWidget {
  final IwishFeedbackMoodType? selectedMood;
  final void Function(IwishFeedbackMoodType) onMoodSelected;
  const IwishFeedbackMood({
    super.key,
    this.selectedMood,
    required this.onMoodSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: IwishFeedbackMoodType.values
          .map(
            (e) => Expanded(
              child: Material(
                borderRadius: BorderRadius.circular(10),
                color: e == selectedMood
                    ? NonThemeColor.color3
                    : context.color.surface_base_primary,
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () => onMoodSelected(e),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 34),
                    child: SvgPicture.asset(
                      'assets/icons/svg/ic_face_${e.name}.svg',
                      package: PackageConfig.packageName,
                      colorFilter: ColorFilter.mode(
                        selectedMood == e
                            ? Colors.white
                            : NonThemeColor.color4,
                        BlendMode.srcATop,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
          .expand((element) => [element, const SizedBox(width: 8)])
          .take(5)
          .toList(),
    );
  }
}

enum IwishFeedbackMoodType {
  happy,
  neutral,
  upset,
}
