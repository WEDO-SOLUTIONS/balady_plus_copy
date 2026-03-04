// ignore_for_file: unused_local_variable, prefer_expression_function_bodies, avoid_print
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:example/widgetbook_app/widgets/demo_tile.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

enum InputDemoStates {
  normal,
  error,
  disabled,
}

enum InputPrefixTypeDemo {
  widget,
  icon,
  bigWidget,
}

final typingFocusNode = FocusNode();
final focusedFocusNode = FocusNode();
final focusNodeMulti = FocusNode();
@widgetbook.UseCase(
  name: '09. Input',
  type: Widget,
)
Widget inputDemo(BuildContext context) {
  final isLTR = Directionality.of(context) == TextDirection.rtl;

  final showLabel = context.knobs.boolean(label: 'Enable Label text');
  final showSupportingText = context.knobs.boolean(label: 'Enable supporting text');
  final showHintText = context.knobs.boolean(label: 'Enable hint text');
  final showPrefix = context.knobs.boolean(label: 'Enable prefix icon');
  final prefixType = context.knobs.list(label: 'Prefix type', options: InputPrefixTypeDemo.values);

  final background = context.knobs.list(label: 'Background', options: BaladyInputBackground.values);
  final backgroundColor = switch (background) {
    BaladyInputBackground.color => context.colors.backgroundSurface4,
    BaladyInputBackground.white => Colors.white,
  };

  final textLTR = isLTR ? 'left to right' : 'right to left';

  final width = context.knobs.double.slider(label: 'Width', min: 200, max: 450, initialValue: 375);

  FocusScope.of(context).requestFocus(typingFocusNode);
  FocusScope.of(context).requestFocus(focusedFocusNode);

  final states = context.knobs.list(
    label: 'States',
    options: [
      InputDemoStates.normal,
      InputDemoStates.error,
      InputDemoStates.disabled,
    ],
  );

  final prefix = switch (prefixType) {
    InputPrefixTypeDemo.widget => BaladyInputAffixWidget(
        widget: Container(
          height: 12,
          width: 24,
          color: Colors.amber,
        ),
        width: 24,
      ),
    InputPrefixTypeDemo.icon => const BaladyInputAffixIcon(icon: GeneralIcons.star),
    InputPrefixTypeDemo.bigWidget => BaladyInputAffixWidget(
        customPadding: const EdgeInsetsDirectional.all(0),
        widget: Column(
          children: [
            const Text(
              'Hello',
              style: TextStyle(fontSize: 12),
            ),
            Container(
              height: 12,
              width: 48,
              color: Colors.amber,
            ),
            const Text(
              'Bye',
              style: TextStyle(fontSize: 12),
            )
          ],
        ),
        width: 48,
      ),
  };

  return Material(
    color: Theme.of(context).brightness == Brightness.light ? backgroundColor : Colors.black26,
    child: GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DemoTile(title: 'bg: ${background.name}'),
              const SizedBox(height: 24),
              DemoTile(title: textLTR),
              const SizedBox(height: 24),
              DemoTile(title: states.name),
              const SizedBox(height: 24),
              DemoTile(
                  title:
                      'label: ${showLabel ? 'yes' : 'no'}, support text: ${showSupportingText ? 'yes' : 'no'}, hint text: ${showHintText ? 'yes' : 'no'}'),
              const SizedBox(height: 24),
              Container(
                width: width,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red),
                ),
                child: Builder(builder: (context) {
                  switch (states) {
                    case InputDemoStates.normal:
                      return _buildNormalState(
                        prefixType: prefix,
                        background: background,
                        isArabic: isLTR,
                        showLabel: showLabel,
                        showSupportingText: showSupportingText,
                        showHintText: showHintText,
                      );
                    case InputDemoStates.error:
                      return _buildErrorState(
                        background: background,
                        isArabic: isLTR,
                        showLabel: true,
                        showSupportingText: showSupportingText,
                        showHintText: showHintText,
                        // focusNode: typingFocusNode,
                        // controller: TextEditingController(text: 'Typing...'),
                      );

                    case InputDemoStates.disabled:
                      return _buildDisabledState(
                        background: background,
                        isArabic: isLTR,
                        showLabel: showLabel,
                        showSupportingText: showSupportingText,
                        showHintText: showHintText,
                        // focusNode: focusedFocusNode
                      );
                  }
                }),
              ),
              const SizedBox(height: Spacing.$8x),
              SizedBox(
                width: width,
                child: _buildMultipleLineState(
                  isArabic: isLTR,
                  showLabel: showLabel,
                  showSupportingText: showSupportingText,
                  showHintText: showHintText,
                  background: background,
                ),
              ),
              const SizedBox(height: Spacing.$8x),
              Container(
                width: width,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red),
                ),
                child: _buildV2LineState(
                  prefixType: prefix,
                  isArabic: isLTR,
                  showLabel: showLabel,
                  showSupportingText: showSupportingText,
                  showHintText: showHintText,
                  background: background,
                  focusNode: FocusNode(),
                ),
              ),
              const SizedBox(height: Spacing.$8x),
              Container(
                width: width,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red),
                ),
                child: _buildV2MultiLineState(
                  prefixType: prefix,
                  isArabic: isLTR,
                  showLabel: showLabel,
                  showSupportingText: showSupportingText,
                  showHintText: showHintText,
                  background: background,
                  focusNode: focusNodeMulti,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget _buildNormalState({
  required BaladyInputAffixBase? prefixType,
  required bool isArabic,
  required bool showLabel,
  required bool showSupportingText,
  required bool showHintText,
  required BaladyInputBackground background,
  FocusNode? focusNode,
  TextEditingController? controller,
}) {
  return Padding(
    padding: EdgeInsets.zero,
    child: Column(
      children: [
        BaladyInput(
          prefixConfig: prefixType,
          background: background,
          focusNode: focusNode,
          labelText: showLabel ? _getLabel(isArabic) : null,
          supportingText: showSupportingText ? _getSupportingText(isArabic) : null,
          hintText: showHintText ? _getHintText(isArabic) : null,
          controller: controller,
        ),
      ],
    ),
  );
}

Widget _buildMultipleLineState({
  required bool isArabic,
  required bool showLabel,
  required bool showSupportingText,
  required bool showHintText,
  required BaladyInputBackground background,
  FocusNode? focusNode,
  TextEditingController? controller,
}) {
  return Padding(
    padding: const EdgeInsets.all(Spacing.$2x),
    child: BaladyInput(
      maxLines: 4,
      focusNode: focusNode,
      labelText: showLabel ? _getLabel(isArabic) : null,
      supportingText: showSupportingText ? _getSupportingText(isArabic) : null,
      hintText: showHintText ? _getHintText(isArabic) : null,
      controller: controller,
      background: background,
    ),
  );
}

Widget _buildErrorState({
  required bool isArabic,
  required bool showLabel,
  required bool showSupportingText,
  required bool showHintText,
  required BaladyInputBackground background,
}) {
  return Padding(
    padding: const EdgeInsets.all(Spacing.$2x),
    child: BaladyInput(
      background: background,
      labelText: showLabel ? _getLabel(isArabic) : null,
      supportingText: showSupportingText ? _getSupportingText(isArabic) : null,
      hintText: showHintText ? _getHintText(isArabic) : null,
      errorText: _getSupportingText(isArabic),
    ),
  );
}

Widget _buildDisabledState({
  required bool isArabic,
  required bool showLabel,
  required bool showSupportingText,
  required bool showHintText,
  required BaladyInputBackground background,
}) {
  return Padding(
    padding: const EdgeInsets.all(Spacing.$2x),
    child: BaladyInput(
      readOnly: true,
      background: background,
      labelText: showLabel ? _getLabel(isArabic) : null,
      supportingText: showSupportingText ? _getSupportingText(isArabic) : null,
      hintText: showHintText ? _getHintText(isArabic) : null,
      enabled: false,
      controller: TextEditingController(text: _getDefaultText(isArabic)),
    ),
  );
}

Widget _buildV2LineState({
  required BaladyInputAffixBase? prefixType,
  required bool isArabic,
  required bool showLabel,
  required bool showSupportingText,
  required bool showHintText,
  required BaladyInputBackground background,
  FocusNode? focusNode,
  TextEditingController? controller,
}) {
  return BaladyTextInput(
    prefixConfig: prefixType,
    label: showLabel ? BaladyInputLabel(text: _getLabel(isArabic)) : null,
    config: BaladyInputConfig(
      focusNode: typingFocusNode,
      hintText: showHintText ? _getHintText(isArabic) : null,
      background: background,
    ),
    supportingText: showSupportingText
        ? BaladySupportingText(
            text: _getSupportingText(isArabic),
            maxLength: 99,
          )
        : null,
    controller: controller,
  );
}

Widget _buildV2MultiLineState({
  required BaladyInputAffixBase? prefixType,
  required bool isArabic,
  required bool showLabel,
  required bool showSupportingText,
  required bool showHintText,
  required BaladyInputBackground background,
  FocusNode? focusNode,
  TextEditingController? controller,
}) {
  return BaladyTextInput(
    prefixConfig: prefixType,
    label: showLabel ? BaladyInputLabel(text: _getLabel(isArabic)) : null,
    config: BaladyInputConfig(
      stateKey: GlobalKey(),
      maxLines: 5,
      hintText: showHintText ? _getHintText(isArabic) : null,
      background: background,
      focusNode: focusNode,
    ),
    suffixConfig: BaladyInputAffixCleanIcon(
      onPressed: () {
        print('Hello');
      },
      cleanOnPressed: false,
    ),
    supportingText: showSupportingText
        ? BaladySupportingText(
            text: _getSupportingText(isArabic),
            maxLength: 99,
          )
        : null,
    controller: controller,
  );
}

String _getLabel(bool isArabic) {
  return isArabic ? 'نص التسمية' : 'Label text';
}

String _getDefaultText(bool isArabic) {
  return isArabic ? 'إبحث فى الرياض' : 'I like the city and I want to live there';
}

String _getSupportingText(bool isArabic) {
  return isArabic ? 'النص الداعم' : 'Supporting text';
}

String _getHintText(bool isArabic) {
  return isArabic ? 'إبحث فى الرياض' : 'Share your opinion';
}
