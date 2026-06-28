import 'package:balady_plus/mini_apps_engine/helper/responsive_extension.dart';
import 'package:flutter/material.dart';

//!
class CustomNumberOfAppsSubCard extends StatelessWidget {
  final int count; // Add count parameter

  const CustomNumberOfAppsSubCard({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.w(64.37),
      height: context.h(64.37),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark ? Color(0xFF012F41) : Color(0XFFE5EBED),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            "+$count", // Dynamic count
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              //   color: Color(0XFF242424),
            ),
          ),
        ),
      ),
    );
  }
}
