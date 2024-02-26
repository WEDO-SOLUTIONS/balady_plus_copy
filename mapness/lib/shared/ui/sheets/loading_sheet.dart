import 'package:flutter/material.dart';
import 'package:mapness/shared/ui/loading/loading_big.dart';

class LoadingSheet extends StatelessWidget {
  final String? text;
  const LoadingSheet({Key? key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: const SizedBox(
          height: 265,
          width: double.infinity,
          child: LoadingBig(),
        ),
      );
}
