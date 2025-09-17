import 'package:balady_uikit/core/colors/non_theme_colors.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IwishFeedbackMood extends StatelessWidget {
  const IwishFeedbackMood({
    required this.onMoodSelected,
    super.key,
    this.selectedMood,
  });
  final IwishFeedbackMoodType? selectedMood;
  final void Function(IwishFeedbackMoodType) onMoodSelected;

  @override
  Widget build(BuildContext context) => Row(
        children: IwishFeedbackMoodType.values
            .map(
              (e) => Expanded(
                child: Material(
                  borderRadius: BorderRadius.circular(10),
                  color: e == selectedMood ? NonThemeColor.color3 : context.colors.backgroundSurface1,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () => onMoodSelected(e),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 34,
                      ),
                      child: SvgPicture.asset(
                        'assets/icons/svg/ic_face_${e.name}.svg',
                        colorFilter: ColorFilter.mode(
                          selectedMood == e ? Colors.white : NonThemeColor.color4,
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

enum IwishFeedbackMoodType {
  happy,
  neutral,
  upset,
}
