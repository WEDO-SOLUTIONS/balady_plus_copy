import 'package:flutter/material.dart';

class AppCloseButton extends StatelessWidget {
  final VoidCallback onPressed;

  const AppCloseButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Ink(
        decoration: BoxDecoration(
          color: const Color(0xfff2f7f8),
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
