import 'package:flutter/material.dart';

class HappinessTagWidget extends StatelessWidget {
  final String tag;
  final IconData icon;
  final void Function() onPressed;
  final bool isSelected;

  const HappinessTagWidget({
    super.key,
    required this.tag,
    required this.icon,
    required this.onPressed,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
            color:
                isSelected ? const Color(0xff4CA5B4) : const Color(0x194CA5B4),
            width: 2),
        color: const Color(0xfff2f8f9),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onPressed,
        child: Container(
          height: 70,
          width: 58,
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon),
              const Spacer(),
              Text(tag),
            ],
          ),
        ),
      ),
    );
  }
}
