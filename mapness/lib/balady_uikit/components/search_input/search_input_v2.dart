import 'package:balady_uikit/balady_uikit.dart' hide BaladyTextInput;
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:mapness/balady_uikit/components/text_input/input.dart';

/// The widget that represents the search input with a back button.
/// It is used in the search bar.
/// We need to set the [isArabic], the [searchInput] and [onBackButtonPressed] to make it work.
///
/// Example:
/// ```dart
/// final searchLine = BaladySearchWithBackButton(
///     searchInput: BaladyInput.search(
///     hintText: 'Search',
///     labelText: 'Label text',
///    ),
///    onBackButtonPressed: () => {},
/// );
/// ```
///
/// See also:
/// * [Figma]
/// https://www.figma.com/file/owbsr9Pf0mQSEHXlbiPGOv/Balady-%E2%80%93-Components-Library?type=design&node-id=2330%3A34846&mode=design&t=I6T4o2noN7Gm85EQ-1
class BaladySearchWithBackButtonV2 extends StatelessWidget {
  final BaladyTextInput searchInput;
  final SearchBackOption? option;

  const BaladySearchWithBackButtonV2({
    required this.searchInput,
    this.option,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final _option = option;
    if (_option == null) {
      return searchInput;
    }

    const space = Spacing.$3x;

    return Row(
      children: [
        Expanded(child: searchInput),
        space.widthBox,
        switch (_option) {
          SearchTextBackOption() => CupertinoButton(
              padding: _option.padding,
              minSize: 0,
              borderRadius: BorderRadius.circular(8),
              onPressed: _option.onPressed,
              child: Text(
                _option.text,
                style: context.textStyles.bodySmallMedium.copyWith(
                  color: context.colors.accentDefault,
                  // We have to change the height of the text to center it.
                  height: 1.05,
                ),
              ),
            ),
          SearchIconBackOption() => AppButton(
              buttonColorScheme: ButtonColorScheme.neutral,
              buttonType: ButtonType.secondary,
              primaryIcon: _option.icon,
              onTap: _option.onPressed,
              padding: const EdgeInsets.all(0),
              innerPadding: const EdgeInsets.symmetric(horizontal: Spacing.$2x),
            ),
        },
      ],
    );
  }
}
