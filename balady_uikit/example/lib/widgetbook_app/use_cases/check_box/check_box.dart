import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'CheckBox',
  type: Widget,
)
Widget checkBoxWork(BuildContext context) => SizedBox(
      width: 400,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 140),
              Text('Enabled', style: context.textStyles.bodySmallSemiBold),
              const SizedBox(width: Spacing.$4x),
              Text('Disabled', style: context.textStyles.bodySmallSemiBold),
              const SizedBox(width: Spacing.$4x),
            ],
          ),
          const SizedBox(height: Spacing.$4x),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 100,
                child: Text('Unselected', style: context.textStyles.bodySmallSemiBold),
              ),
              const SizedBox(width: Spacing.$4x),
              const BaladyCheckBox(state: BaladyCheckBoxState.unchecked, disable: false),
              const SizedBox(width: Spacing.$4x),
              const BaladyCheckBox(state: BaladyCheckBoxState.unchecked, disable: true),
              const SizedBox(width: Spacing.$4x),
            ],
          ),
          const SizedBox(height: Spacing.$4x),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 100,
                child: Text('Selected', style: context.textStyles.bodySmallSemiBold),
              ),
              const SizedBox(width: Spacing.$4x),
              const BaladyCheckBox(state: BaladyCheckBoxState.checked, disable: false),
              const SizedBox(width: Spacing.$4x),
              const BaladyCheckBox(state: BaladyCheckBoxState.checked, disable: true),
              const SizedBox(width: Spacing.$4x),
            ],
          ),
          const SizedBox(height: Spacing.$4x),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 100,
                child: Text('Indeterminate', style: context.textStyles.bodySmallSemiBold),
              ),
              const SizedBox(width: Spacing.$4x),
              const BaladyCheckBox(state: BaladyCheckBoxState.indeterminate, disable: false),
              const SizedBox(width: Spacing.$4x),
              const BaladyCheckBox(state: BaladyCheckBoxState.indeterminate, disable: true),
              const SizedBox(width: Spacing.$4x),
            ],
          ),
          const SizedBox(height: Spacing.$12x),
          Row(
            children: [
              Text('Pressed', style: context.textStyles.bodySmallSemiBold),
              const SizedBox(width: Spacing.$4x),
              BaladyCheckBox(
                state: BaladyCheckBoxState.indeterminate,
                disable: false,
                onChanged: (val) {},
              ),
            ],
          ),
        ],
      ),
    );
