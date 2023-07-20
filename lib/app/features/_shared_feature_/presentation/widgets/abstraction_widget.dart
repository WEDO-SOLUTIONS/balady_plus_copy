import 'package:flutter/material.dart';

abstract class AbstractionWidget extends StatelessWidget {
  final Widget child;

  const AbstractionWidget(this.child, {super.key});

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
