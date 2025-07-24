import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/pdf/core/image_path.dart';

class ContainerRequir extends StatelessWidget {
  const ContainerRequir({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 60,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Color.fromARGB(126, 215, 229, 229),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SvgPicture.asset(ImagePath.circle),
              Flexible(
                child: Text(
                  'الصور المعروضة توضيحية ولا تتحدد شكل المخالفة بشكل خاص',
                  style: TextStyle(
                    color: Color(0xFF52525B),
                    fontSize: 14,
                    fontFamily: 'packages/balady_uikit/Frutiger',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
