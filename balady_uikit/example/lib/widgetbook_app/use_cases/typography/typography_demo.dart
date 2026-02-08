import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:urbi_utils/urbi_utils.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Typography',
  type: TypographyTest,
)
Widget typographyDemo(BuildContext context) {
  return const TypographyTest();
}

class TypographyTest extends StatefulWidget {
  const TypographyTest({
    super.key,
  });

  @override
  State<TypographyTest> createState() => _TypographyTestState();
}

enum TextStylesDemo {
  bodyLargeMedium,
  bodyLargeRegular,
  bodyLargeSemiBold,
  bodySmallMedium,
  bodySmallRegular,
  bodySmallSemiBold,
  buttonL,
  buttonM,
  captionLargeMedium,
  captionLargeRegular,
  captionLargeSemiBold,
  captionMediumMedium,
  captionMediumRegular,
  captionMediumSemiBold,
  captionSmallMedium,
  captionSmallRegular,
  captionSmallSemiBold,
  h1Medium,
  h1SemiBold,
  h2Medium,
  h2SemiBold,
  h3Medium,
  h3SemiBold,
  h4Medium,
  h4SemiBold,
}

class _TypographyTestState extends State<TypographyTest> {
  @override
  Widget build(BuildContext context) {
    final stylesKnob = context.knobs
        .list(label: 'Text Styles', options: TextStylesDemo.values);
    final mapOfStyles = {
      TextStylesDemo.bodyLargeMedium: context.textStyles.bodyLargeMedium,
      TextStylesDemo.bodyLargeRegular: context.textStyles.bodyLargeRegular,
      TextStylesDemo.bodyLargeSemiBold: context.textStyles.bodyLargeSemiBold,
      TextStylesDemo.bodySmallMedium: context.textStyles.bodySmallMedium,
      TextStylesDemo.bodySmallRegular: context.textStyles.bodySmallRegular,
      TextStylesDemo.bodySmallSemiBold: context.textStyles.bodySmallSemiBold,
      TextStylesDemo.buttonL: context.textStyles.buttonL,
      TextStylesDemo.buttonM: context.textStyles.buttonM,
      TextStylesDemo.captionLargeMedium: context.textStyles.captionLargeMedium,
      TextStylesDemo.captionLargeRegular:
          context.textStyles.captionLargeRegular,
      TextStylesDemo.captionLargeSemiBold:
          context.textStyles.captionLargeSemiBold,
      TextStylesDemo.captionMediumMedium:
          context.textStyles.captionMediumMedium,
      TextStylesDemo.captionMediumRegular:
          context.textStyles.captionMediumRegular,
      TextStylesDemo.captionMediumSemiBold:
          context.textStyles.captionMediumSemiBold,
      TextStylesDemo.captionSmallMedium: context.textStyles.captionSmallMedium,
      TextStylesDemo.captionSmallRegular:
          context.textStyles.captionSmallRegular,
      TextStylesDemo.captionSmallSemiBold:
          context.textStyles.captionSmallSemiBold,
      TextStylesDemo.h1Medium: context.textStyles.h1Medium,
      TextStylesDemo.h1SemiBold: context.textStyles.h1SemiBold,
      TextStylesDemo.h2Medium: context.textStyles.h2Medium,
      TextStylesDemo.h2SemiBold: context.textStyles.h2SemiBold,
      TextStylesDemo.h3Medium: context.textStyles.h3Medium,
      TextStylesDemo.h3SemiBold: context.textStyles.h3SemiBold,
      TextStylesDemo.h4Medium: context.textStyles.h4Medium,
      TextStylesDemo.h4SemiBold: context.textStyles.h4SemiBold,
    };
    final isAr = Directionality.of(context) == TextDirection.rtl;
    final text = context.knobs.string(
        label: 'Your text',
        initialValue: isAr
            ? 'السعادة البشرية، فلا أحد يرفض أو يكره أو يتجنب الشعور بالسعادة، ولكن بفضل هؤ'
            : 'Fox jumps over the lazy dog and runs away. 1234567890');
    final children = mapOfStyles.entries
        .map((e) => fontContent(e.key.name, e.value, context, text));

    return Container(
      padding: const EdgeInsets.all(20),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          textDirection: TextDirection.ltr,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Your text, style: ${stylesKnob.name}',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
            ),
            Text(text, style: mapOfStyles[stylesKnob]),
            const Divider(),
            Text(
              'Table of typography for font "${mapOfStyles[stylesKnob]?.fontFamily}" font family',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 16),
            ...children.map((e) => e).toList()
          ],
        ),
      ),
    );
  }

  Widget fontContent(
    String name,
    TextStyle textStyle,
    BuildContext context,
    String text,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: textStyle.copyWith(
            color: context.colors.foregroundDefault,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Name: $name',
          style: context.textStyles.bodySmallMedium
              .copyWith(color: context.colors.foregroundSoft),
        ),
        const SizedBox(height: 4),
        Text(
          'Font weight: ${textStyle.fontWeight?.value}',
          style: context.textStyles.bodySmallMedium
              .copyWith(color: context.colors.foregroundSoft),
        ),
        const SizedBox(height: 4),
        Text(
          'Font size: ${textStyle.fontSize}',
          style: context.textStyles.bodySmallMedium
              .copyWith(color: context.colors.foregroundSoft),
        ),
        const SizedBox(height: 4),
        Text(
          'Line height: ${textStyle.height?.toStringAsFixed(2)}',
          style: context.textStyles.bodySmallMedium
              .copyWith(color: context.colors.foregroundSoft),
        ),
        const SizedBox(height: 4),
        Text(
          'Letter spacing: ${textStyle.letterSpacing?.toStringAsFixed(0)}',
          style: context.textStyles.bodySmallMedium
              .copyWith(color: context.colors.foregroundSoft),
        ),
        const SizedBox(height: 32),
      ],
    );
    return Row(
      textDirection: TextDirection.ltr,
      children: [
        Expanded(
          flex: 5,
          child: EditableText(
            focusNode: FocusNode(),
            cursorColor: Colors.black,
            controller: TextEditingController(text: name),
            textDirection: TextDirection.ltr,
            backgroundCursorColor: Colors.black,
            style: textStyle.copyWith(color: context.colors.foregroundDefault),
          ),
        ),
        ...<Widget>[
          Text(
            textDirection: TextDirection.ltr,
            '${textStyle.fontWeight?.value}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)
                .copyWith(color: context.colors.foregroundDefault),
          ),
          Text(
            textDirection: TextDirection.ltr,
            '${textStyle.fontSize}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)
                .copyWith(color: context.colors.foregroundDefault),
          ),
          Text(
            textDirection: TextDirection.ltr,
            '${textStyle.height?.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)
                .copyWith(color: context.colors.foregroundDefault),
          ),
          Text(
            textDirection: TextDirection.ltr,
            '${textStyle.letterSpacing?.toStringAsFixed(0)}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)
                .copyWith(color: context.colors.foregroundDefault),
          ),
          Text(
            textDirection: TextDirection.ltr,
            '${textStyle.fontFamily}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)
                .copyWith(color: context.colors.foregroundDefault),
          ),
        ]
            .insertBetween(
              const SizedBox(
                width: 10,
              ),
            )
            .map((e) => Expanded(child: e))
            .toList()
      ],
    );
  }
}
