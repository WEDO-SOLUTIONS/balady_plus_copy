import 'package:balady_plus/mini_apps_engine/helper/responsive_extension.dart';
import 'package:flutter/material.dart';

//!
class CustomNumberOfSubs extends StatelessWidget {
  final int count;

  const CustomNumberOfSubs({super.key, required this.count});

  @override
  Widget build(BuildContext context) => SizedBox(
    width: context.w(36),
    height: context.h(36),
    child: Padding(
      padding: const EdgeInsets.all(2),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF01222E) : Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text("+$count", style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
        ),
      ),
    ),
  );
}
