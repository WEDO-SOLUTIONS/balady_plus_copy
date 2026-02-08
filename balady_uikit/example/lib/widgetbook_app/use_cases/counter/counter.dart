import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

///TODO межстрочный интервал rtl убрать
@widgetbook.UseCase(
  name: 'Counter',
  type: Widget,
)
Widget counterWork(BuildContext context) {
  final counter = AnimatedCounter(
    count: context.knobs.boolean(label: 'Size S') ? null : 10,
  );

  final isArabic = Directionality.of(context) == TextDirection.rtl;

  return ColoredBox(
    color: Colors.white,
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isArabic)
            Text('RTL', style: context.textStyles.h1Medium)
          else
            Text('LTR', style: context.textStyles.h2Medium),
          const SizedBox(height: Spacing.$12x),
          Text('Component', style: context.textStyles.h2Medium),
          const SizedBox(height: Spacing.$8x),
          Row(
            children: [
              SizedBox(
                width: 100,
                child: Text(
                  'Primary',
                  style: context.textStyles.bodyLargeRegular.copyWith(color: context.colors.foregroundSoft),
                ),
              ),
              SizedBox(
                width: 50,
                child: Text(
                  'S',
                  style: context.textStyles.bodyLargeRegular.copyWith(color: context.colors.foregroundSoft),
                ),
              ),
              const SizedBox(
                width: 50,
                child: Center(child: Counter()),
              ),
              const SizedBox(
                width: 50,
                child: Center(
                    child: Counter(
                  count: 28,
                )),
              ),
            ],
          ),
          const SizedBox(height: 19),
          Row(
            children: [
              SizedBox(
                width: 100,
                child: Text(
                  'Primary',
                  style: context.textStyles.bodyLargeRegular.copyWith(color: context.colors.foregroundSoft),
                ),
              ),
              SizedBox(
                width: 50,
                child: Text(
                  'M',
                  style: context.textStyles.bodyLargeRegular.copyWith(color: context.colors.foregroundSoft),
                ),
              ),
              const SizedBox(
                width: 50,
                child: Center(child: Counter(count: 2)),
              ),
            ],
          ),
          const SizedBox(height: Spacing.$5x),
          Row(
            children: [
              SizedBox(
                width: 100,
                child: Text(
                  'Secondary',
                  style: context.textStyles.bodyLargeRegular.copyWith(color: context.colors.foregroundSoft),
                ),
              ),
              SizedBox(
                width: 50,
                child: Text(
                  'M',
                  style: context.textStyles.bodyLargeRegular.copyWith(color: context.colors.foregroundSoft),
                ),
              ),
              SizedBox(
                width: 50,
                child: Center(child: Counter(count: 2, color: context.colors.neutralDefault)),
              ),
            ],
          ),
          const SizedBox(height: Spacing.$8x),
          Divider(color: context.colors.neutralDefault),
          const SizedBox(height: Spacing.$8x),
          Text('Examples', style: context.textStyles.h2Medium),
          const SizedBox(height: Spacing.$5x),
          SizedBox(
            width: 280,
            child: Text(
              'Examples of how the Counter works with different numbers:',
              style: context.textStyles.bodyLargeRegular.copyWith(
                color: context.colors.foregroundDefault,
              ),
            ),
          ),
          const SizedBox(height: Spacing.$4x),
          const Counter(count: 2),
          const SizedBox(height: Spacing.$1_5x),
          const Counter(count: 15),
          const SizedBox(height: Spacing.$1_5x),
          counter,
          const SizedBox(height: Spacing.$8x),
          Divider(color: context.colors.neutralDefault),
          const SizedBox(height: Spacing.$8x),
          SizedBox(
            width: 280,
            child: Text(
              'Examples of how the Counter looks with different colors:',
              style: context.textStyles.bodyLargeRegular.copyWith(
                fontWeight: FontWeight.w400,
                color: context.colors.foregroundDefault,
              ),
            ),
          ),
          const SizedBox(height: Spacing.$4x),
          const Row(
            children: [
              Counter(),
              SizedBox(width: Spacing.$4x),
              Counter(count: 2),
            ],
          ),
          const SizedBox(height: Spacing.$2x),
          Row(
            children: [
              Counter(color: context.colors.accentSecondaryDefault),
              const SizedBox(width: Spacing.$4x),
              Counter(count: 2, color: context.colors.accentSecondaryDefault),
            ],
          ),
          const SizedBox(height: Spacing.$2x),
          Row(
            children: [
              Counter(color: context.colors.successDefault),
              const SizedBox(width: Spacing.$4x),
              Counter(count: 2, color: context.colors.successDefault),
            ],
          ),
          const SizedBox(height: Spacing.$2x),
          Row(
            children: [
              Counter(color: context.colors.accentContainerActive),
              const SizedBox(width: Spacing.$4x),
              Counter(count: 2, color: context.colors.accentContainerActive),
            ],
          ),
        ],
      ),
    ),
  );
}
