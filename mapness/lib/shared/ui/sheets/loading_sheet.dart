import 'package:flutter/material.dart';
import 'package:mapness/shared/ui/loading/loading_big.dart';

class LoadingSheet extends StatelessWidget {
  const LoadingSheet({super.key, this.text});
  final String? text;

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
