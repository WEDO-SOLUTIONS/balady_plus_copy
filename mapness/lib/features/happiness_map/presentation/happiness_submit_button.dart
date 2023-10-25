import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HappinessSubmitButton extends ConsumerWidget {
  final VoidCallback onPress;
  const HappinessSubmitButton({Key? key, required this.onPress})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const color = Color(0xff4ba5b4);

    return Ink(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: color,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onPress,
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 14),
          child: Text(
            'send feedback',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
