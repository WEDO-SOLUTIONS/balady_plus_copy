import 'package:balady_uikit/core/utils/constants.dart';
import 'package:balady_uikit/gen/assets/assets.gen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PinOnMapAreaDemo extends StatelessWidget {
  const PinOnMapAreaDemo({super.key});

  @override
  Widget build(BuildContext context) => SvgPicture.asset(
        Assets.icons.svg.mapControls.icPinGreen.path,
        package: packageName,
        fit: BoxFit.scaleDown,
      );
}
