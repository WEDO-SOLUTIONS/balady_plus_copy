// ignore_for_file: prefer_expression_function_bodies

import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';

class DemoContainer extends StatelessWidget {
  final Widget child;
  final String title;
  final double? height;
  final bool wrapInLRT;

  const DemoContainer({
    required this.child,
    required this.title,
    super.key,
    this.height,
    this.wrapInLRT = true,
  });

  @override
  Widget build(BuildContext context) {
    return _Wrapper(
      wrapInLRT: wrapInLRT,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 119,
            alignment: Alignment.center,
            margin: const EdgeInsets.only(left: 16, right: 16),
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
              color: context.colors.accentDefault,
            ),
            child: Text(
              title,
              style: context.textStyles.h1SemiBold.copyWith(
                color: Colors.white,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: height ?? 200,
            alignment: Alignment.center,
            margin: const EdgeInsets.only(left: 16, right: 16),
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              border: Border.all(
                color: context.colors.accentDefault,
              ),
              color: const Color(0xFFF5F7FA),
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}

class _Wrapper extends StatelessWidget {
  final bool wrapInLRT;
  final Widget child;
  const _Wrapper({required this.wrapInLRT, required this.child});

  @override
  Widget build(BuildContext context) {
    if (wrapInLRT) {
      return Directionality(textDirection: TextDirection.ltr, child: child);
    }
    return child;
  }
}
