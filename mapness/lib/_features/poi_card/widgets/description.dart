import 'package:flutter/material.dart';
import 'package:mapness/_features/poi_card/widgets/card_content.dart';

class Description extends StatelessWidget {
  const Description({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return CardContent(
      child: Text(text),
    );
  }
}
