import 'package:balady_plus/app/features/_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class ButtonInCard extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const ButtonInCard({
    super.key,
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButtonWidget.primaryCustom(
          onPressed: onPressed,
          text: text,
        ),
      ),
    );
  }
}
