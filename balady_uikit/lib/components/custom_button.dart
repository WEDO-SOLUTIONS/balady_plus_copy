import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;


@widgetbook.UseCase(
  name: 'Customizable',
  type: CustomButton,
)
CustomButton customizableButton(BuildContext context) {
  return CustomButton(
    title: context.knobs.string(label: 'Title', initialValue: 'Click Me'),
    onPressed: context.knobs.boolean(label: 'Enabled', initialValue: true)
        ? () {}
        : null,
  );
}

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.title,
    this.onPressed,
  }) : super(key: key);
  final String title;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(title),
    );
  }
}