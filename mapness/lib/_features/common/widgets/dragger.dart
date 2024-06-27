import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SheetDragger extends StatelessWidget {
  const SheetDragger({super.key});

  @override
  Widget build(BuildContext context) => Container(
        height: 4,
        width: 40,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: const BorderRadius.all(Radius.circular(99)),
        ),
      );
}
