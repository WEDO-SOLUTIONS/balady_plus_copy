import 'package:balady_uikit/balady_uikit.dart';
import 'package:example/widgetbook_app/widgets/demo_tile.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

enum SearchDemoStates {
  cancel,
  cross,
}

@widgetbook.UseCase(
  name: '10. Search',
  type: Widget,
)
Widget searchDemo(BuildContext context) {
  final isArabic = Directionality.of(context) == TextDirection.rtl;
  final textLTR = isArabic ? 'Right to left' : 'Left to right';
  final width = context.knobs.double.slider(label: 'Width', min: 200, max: 500, initialValue: 375);

  final showBackButton = context.knobs.boolean(label: 'Show back button');
  final states = context.knobs.list(
    label: 'States',
    options: [
      SearchDemoStates.cancel,
      SearchDemoStates.cross,
    ],
  );
  return Material(
    color: Colors.white,
    child: SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DemoTile(title: textLTR),
            const SizedBox(height: 24),
            DemoTile(title: 'Close method: ${states.name}'),
            const SizedBox(height: 24),
            Container(
              width: width,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red),
              ),
              child: Builder(builder: (context) {
                switch (states) {
                  case SearchDemoStates.cancel:
                    return _buildTextState(
                      isArabic: isArabic,
                      showBackButton: showBackButton,
                    );
                  case SearchDemoStates.cross:
                    return _buildDisabledState(
                      isArabic: isArabic,
                      showBackButton: showBackButton,
                    );
                }
              }),
            ),
            Container(
              width: width,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red),
              ),
              child: _buildV2TextState(isArabic: isArabic, showBackButton: showBackButton),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildTextState({
  required bool isArabic,
  required bool showBackButton,
}) {
  SearchBackOption? option;
  if (showBackButton) {
    option = SearchTextBackOption(
      text: _getCancelText(isArabic),
      onPressed: () => {},
    );
  }
  return BaladySearchWithBackButton(
    searchInput: BaladyInput.searchV2(hintText: _getHintText(isArabic)),
    option: option,
  );
}

Widget _buildDisabledState({
  required bool isArabic,
  required bool showBackButton,
}) {
  SearchBackOption? option;
  if (showBackButton) {
    option = SearchIconBackOption(
      onPressed: () => {},
    );
  }
  return BaladySearchWithBackButton(
    searchInput: BaladyInput.searchV2(
      hintText: _getHintText(isArabic),
      controller: TextEditingController(text: _getDefaultText(isArabic)),
    ),
    option: option,
  );
}

Widget _buildV2TextState({
  required bool isArabic,
  required bool showBackButton,
}) {
  SearchBackOption? option;
  if (showBackButton) {
    option = SearchTextBackOption(
      text: _getCancelText(isArabic),
      onPressed: () => {},
    );
  }
  return BaladySearchWithBackButtonV2(
    searchInput: BaladyTextInput.search(
      config: BaladyInputConfig(
        hintText: _getHintText(isArabic),
      ),
    ),
    option: option,
  );
}

String _getDefaultText(bool isArabic) {
  return isArabic ? 'إبحث فى الرياض' : 'I like the city';
}

String _getHintText(bool isArabic) {
  return isArabic ? 'البحث' : 'Search';
}

String _getCancelText(bool isArabic) {
  return isArabic ? 'إلغاء' : 'Cancel';
}
