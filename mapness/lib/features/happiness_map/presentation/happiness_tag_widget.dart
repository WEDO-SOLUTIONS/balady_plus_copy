import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/core/config/package_config.dart';
import 'package:mapness/features/happiness_map/domain/happiness_tag.dart';

class HappinessTagWidget extends StatelessWidget {
  final HappinessTag tag;
  final void Function() onPressed;
  final bool isSelected;

  const HappinessTagWidget({
    super.key,
    required this.tag,
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
              SvgPicture.asset(
                tag.iconAsset,
                package: PackageConfig.packageName,
              ),
              const Spacer(),
              Text(tag.title),
            ],
          ),
        ),
      ),
    );
  }
}
