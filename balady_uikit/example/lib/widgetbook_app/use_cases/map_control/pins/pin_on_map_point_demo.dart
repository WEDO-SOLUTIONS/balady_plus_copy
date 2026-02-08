import 'package:balady_uikit/core/utils/constants.dart';
import 'package:balady_uikit/gen/assets/assets.gen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PinOnMapPointDemo extends StatelessWidget {
  const PinOnMapPointDemo({super.key});

  @override
  Widget build(BuildContext context) => SvgPicture.asset(
    Assets.icons.svg.mapControls.icPinYellow.path,
    package: packageName,
    fit: BoxFit.scaleDown,
  );
}
