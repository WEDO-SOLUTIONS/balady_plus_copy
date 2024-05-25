import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:mapness/widgets/routing/ui_kit/path_card/path_card_wrapper.dart';

class PathCardLoading extends StatelessWidget {
  final String text;
  const PathCardLoading({required this.text, super.key});

  @override
  Widget build(BuildContext context) => PathCardWrapper(
        alignment: Alignment.center,
        child: Loading(title: text),
      );
}
