import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class AppFeedbackInput extends HookWidget {
  final ValueChanged<bool>? isValid;
  final TextInputAction? textInputAction;
  final TextEditingController textController;

  const AppFeedbackInput({
    required this.textController,
    this.isValid,
    this.textInputAction,
    this.maxCharsAllowed = 1000,
    super.key,
  });

  final int maxCharsAllowed;
  static const _initMaxLines = 9;
  static const _maxLinesAllowed = 15;

  @override
  Widget build(BuildContext context) {
    final focusNode = useFocusNode();
    final maxLines = useState<int>(_initMaxLines);
    final inputState = useState<BaladyInputState>(BaladyInputState.defaultValue);
    final supportingText = useState<String?>(null);

    void calculateMaxLines() {
      // Average char width in pixels for the current font size
      const double averageCharWidth = 10.0;

      // Calculate the width of the text field with padding
      final double textFieldWidth = MediaQuery.sizeOf(context).width - (Spacing.$4x * 2);

      final int charsPerLine = (textFieldWidth / averageCharWidth).floor();

      final int lines = (textController.text.length / charsPerLine).ceil();

      maxLines.value = lines.clamp(_initMaxLines, _maxLinesAllowed);

      final _isNotEmpty = textController.text.isNotEmpty;
      final _isValidLength = textController.text.length <= maxCharsAllowed;
      final _isValid = _isNotEmpty && _isValidLength;
      isValid?.call(_isValid);

      final newStateValue = _isValidLength ? BaladyInputState.defaultValue : BaladyInputState.error;

      if (newStateValue != inputState.value) {
        inputState.value = newStateValue;
      }

      final newTextValue = _isValidLength ? null : context.l10n.appFeedbackCharacterLimitReached;
      if (newTextValue != supportingText.value) {
        supportingText.value = newTextValue;
      }
    }

    useEffect(() {
      textController.addListener(calculateMaxLines);
      return () => textController.removeListener(calculateMaxLines);
    }, [textController]);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
      child: ValueListenableBuilder<int>(
        valueListenable: maxLines,
        builder: (context, maxLinesValue, _) => BaladyTextInput(
          controller: textController,
          inputState: inputState.value,
          config: BaladyInputConfig(
            textStyle: context.textStyles.bodyLargeRegular,
            background: BaladyInputBackground.color,
            textInputAction: textInputAction,
            focusNode: focusNode,
            autofocus: true,
            hintText: context.l10n.appFeedbackTellUsMore,
            maxLines: maxLinesValue,
            isDisposed: false,
          ),
          supportingText: BaladySupportingText(text: supportingText.value, maxLength: maxCharsAllowed),
        ),
      ),
    );
  }
}
