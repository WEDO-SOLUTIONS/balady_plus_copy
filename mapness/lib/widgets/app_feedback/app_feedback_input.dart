import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class AppFeedbackInput extends HookWidget {
  final ValueChanged<bool>? isValid;
  final TextEditingController textController;

  const AppFeedbackInput({required this.textController, this.isValid, super.key});

  static const _initMaxLines = 4;
  static const _maxLinesAllowed = 20;
  static const _maxCharsAllowed = 1000;

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

      maxLines.value = lines.clamp(_initMaxLines, _maxLinesAllowed);

      isValid?.call(textController.text.isNotEmpty && textController.text.length <= _maxCharsAllowed);
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
          ValueListenableBuilder<int>(
            valueListenable: maxLines,
            builder: (context, maxLinesValue, _) => BaladyInput(
              controller: textController,
              focusNode: focusNode,
              autofocus: true,
              hintText: context.l10n.appFeedbackTellUsMore,
              maxLines: maxLinesValue,
              maxLength: _maxCharsAllowed,
              isDisposed: false,
              onValidate: (v) => v != null && v.length != _maxCharsAllowed
                  ? null
                  : context.l10n.appFeedbackCharacterLimitReached, // Show error message if the text length is 1000 only
            ),
          ),
        ],
      ),
    );
  }
}
