import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AppFeedbackInput extends HookWidget {
  final ValueChanged<bool>? isValid;
  final TextEditingController textController;

  const AppFeedbackInput({required this.textController, this.isValid, super.key});

  static const _initMaxLines = 4;

  @override
  Widget build(BuildContext context) {
    final focusNode = useFocusNode();
    final maxLines = useState<int>(_initMaxLines);

    void calculateMaxLines() {
      // Average char width in pixels for the current font size
      const double averageCharWidth = 10.0;

      // Calculate the width of the text field with padding
      final double textFieldWidth = MediaQuery.of(context).size.width - (Spacing.$4x * 2);

      final int charsPerLine = (textFieldWidth / averageCharWidth).floor();

      final int lines = (textController.text.length / charsPerLine).ceil();

      maxLines.value = lines > _initMaxLines ? lines : _initMaxLines;

      isValid?.call(textController.text.isNotEmpty && textController.text.length <= 1000);
    }

    useEffect(() {
      textController.addListener(calculateMaxLines);
      return () => textController.removeListener(calculateMaxLines);
    }, [textController]);

    return Padding(
      padding: const EdgeInsets.all(Spacing.$4x),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WidgetLabel(
            label: 'Leave comment',
            labelStyle: context.textStyleV3.captionMediumRegular.copyWith(
              color: context.colorsV2.foregroundDefault,
            ),
          ),
          Column(
            children: [
              ValueListenableBuilder<int>(
                valueListenable: maxLines,
                builder: (context, maxLinesValue, _) => BaladyInput(
                  controller: textController,
                  focusNode: focusNode,
                  autofocus: true,
                  hintText: 'Tell us more',
                  maxLines: maxLinesValue,
                  maxLength: 1000,
                  onValidate: (v) => v != null && v.length != 10
                      ? null
                      : 'Character limit reached', // Show error message if the text length is 1000 only
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
