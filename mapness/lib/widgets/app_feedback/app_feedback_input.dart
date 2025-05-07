import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class AppFeedbackInput extends HookWidget {
  final ValueChanged<bool>? isValid;
  final TextEditingController textController;

  const AppFeedbackInput({
    required this.textController,
    this.isValid,
    super.key,
  });

  static const _initMaxLines = 4;
  static const _maxLinesAllowed = 7;
  static const _maxCharsAllowed = 1000;

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
      final _isValidLength = textController.text.length <= _maxCharsAllowed;
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
      padding: const EdgeInsets.all(Spacing.$4x),
      child: ValueListenableBuilder<int>(
        valueListenable: maxLines,
        builder: (context, maxLinesValue, _) => BaladyTextInput(
          controller: textController,
          inputState: inputState.value,
          config: BaladyInputConfig(
            focusNode: focusNode,
            autofocus: true,
            hintText: context.l10n.appFeedbackTellUsMore,
            maxLines: maxLinesValue,
            isDisposed: false,
          ),
          supportingText: BaladySupportingText(
            // Show error message if the text length is 1000 only
            text: supportingText.value,
            maxLength: _maxCharsAllowed,
          ),
        ),
      ),
    );
  }
}
