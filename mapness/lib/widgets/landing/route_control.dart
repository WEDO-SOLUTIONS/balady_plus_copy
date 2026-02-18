import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';

class RouteControl extends StatelessWidget {
  final VoidCallback onTap;

  const RouteControl({required this.onTap, super.key});

  @override
  Widget build(BuildContext context) => MapButton(
    onTap: onTap,
    child: GeneralIcons.routeStroke.icon(color: context.colors.foregroundDefault),
  );
}
