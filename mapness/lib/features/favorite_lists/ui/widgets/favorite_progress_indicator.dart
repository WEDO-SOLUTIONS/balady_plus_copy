import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';

class FavoriteProgressIndicator extends StatelessWidget {
  const FavoriteProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) => Center(
    child: SizedBox(
      height: 20,
      width: 20,
      child: CircularProgressIndicator(strokeWidth: 2, color: context.colors.accentDefault),
    ),
  );
}
