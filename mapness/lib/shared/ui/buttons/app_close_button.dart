import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class AppCloseButton extends StatelessWidget {
  final VoidCallback onPressed;

  const AppCloseButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Ink(
        decoration: BoxDecoration(
          color: context.color.surface_base_primary,
          borderRadius: BorderRadius.circular(8),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onPressed,
          child: const Padding(
            padding: EdgeInsets.all(8),
            child: Icon(
              Icons.close,
              color: Color(0xff889097),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomCloseButton extends StatelessWidget {
  const CustomCloseButton({super.key,this.onClose});

  final Function()? onClose;
  final borderRadius = const BorderRadius.all(
    Radius.circular(8),
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Material(
        borderRadius: borderRadius,
        child: InkWell(
          borderRadius: borderRadius,
          onTap: onClose,
          child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(8),
              ),
              color: context.color.text_and_icons_base_primary.withAlpha(10),
            ),
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset(
              "assets/icons/svg/ic_search_close.svg",
              semanticsLabel: 'MinApps Screen',
              package: "mapness",
              color: context.color.text_and_icons_base_primary.withOpacity(0.7),
            ),
          ),
        ),
      ),
    );
  }
}