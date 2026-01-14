import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';

class AddImageButton extends StatelessWidget {
  final void Function() onTap;
  final double size;

  const AddImageButton({required this.onTap, required this.size, super.key});

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(21),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(21),
      child: SizedBox(
        height: size,
        width: size,
        child: ColoredBox(
          color: context.colors.backgroundSurface1,
          child: Center(
            child: Icon(
              GeneralIcons.photo,
              color: context.colors.accentDefault,
              size: size * .4,
            ),
          ),
        ),
      ),
    ),
  );
}
