// ignore_for_file: prefer_expression_function_bodies

import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: '11. Top Bar',
  type: Widget,
)
Widget topBarDemo(BuildContext context) {
  final isArabic = Directionality.of(context) == TextDirection.rtl;
  final isOverflow = context.knobs.boolean(label: 'Show overflow title');
  final title = isArabic ? _arabicText(isOverflow) : _englishText(isOverflow);

  final action = _action(isArabic, isOverflow);

  final showLeadingIcon = context.knobs.boolean(label: 'Show leading icon', initialValue: true);
  final showTrailingIcon = context.knobs.boolean(label: 'Show trailing icon', initialValue: true);
  final showLeadingText = context.knobs.boolean(label: 'Show leading text', initialValue: true);
  final showTrailingText = context.knobs.boolean(label: 'Show trailing text', initialValue: true);

  final leadingAction = ActionModel(
    icon: showLeadingIcon ? GeneralIcons.placeholder : null,
    text: showLeadingText ? action : null,
    onPressed: () {
      if (kDebugMode) {
        print('on leading pressed');
      }
    },
  );
  final trailingAction = ActionModel(
    icon: showTrailingIcon ? GeneralIcons.placeholder : null,
    text: showTrailingText ? action : null,
  );
  return Scaffold(
    appBar: BaladyTopBar.iconAndText(
      colorPressed: context.colors.accentActive,
      colorEnabled: context.colors.accentDefault,
      leading: leadingAction,
      trailing: trailingAction,
      title: title,
    ),
    body: Container(
      color: Colors.green.shade300,
      child: const Center(
        child: Text('Hello World'),
      ),
    ),
  );
}

String _action(bool isArabic, bool isOverflow) {
  if (isArabic) {
    return isOverflow ? 'عملعملعملعمل' : 'عمل';
  } else {
    return isOverflow ? 'Long action text that will not set' : 'Action';
  }
}

String _arabicText(bool isOverflow) {
  if (isOverflow) {
    return 'عملعملعملعمل عنوان عنوانعنوانعنوانعنوانعنوانعنوانعنوانعنوانعنوانعنوانعنوانعنوانعنوانعنوانعنوانعنوان';
  } else {
    return 'عنوان';
  }
}

String _englishText(bool isOverflow) {
  if (isOverflow) {
    return 'Profile settings or a long title to test the text overflow and the centering of the title and the leading and trailing icons';
  } else {
    return 'Title';
  }
}
