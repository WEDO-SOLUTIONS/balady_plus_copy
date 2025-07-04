import 'package:balady_uikit/balady_uikit.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:mapness/widgets/routing/ui_kit/path_card/path_card_wrapper.dart';
import 'package:mapness/widgets/routing/ui_kit/path_card/tools/path_card_size.dart';

/// This widget is used to show a loading message in the path card
/// It will show a loading indicator and a message
class PathCardLoading extends StatelessWidget {
  final String text;
  final RouteSearchOptionsMessage currentType;
  const PathCardLoading({required this.text, required this.currentType, super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SizedBox(
          height: PathCardSize.getCardHeight(type: currentType),
          child: PathCardWrapper(
            alignment: Alignment.center,
            child: Loading(title: text),
          ),
        ),
      );
}
