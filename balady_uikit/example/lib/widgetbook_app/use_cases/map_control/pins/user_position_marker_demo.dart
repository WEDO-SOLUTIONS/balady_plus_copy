import 'package:balady_uikit/core/utils/constants.dart';
import 'package:balady_uikit/gen/assets/assets.gen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UserPositionMarkerDemo extends StatelessWidget {
  final bool direction;
  final bool area;

  const UserPositionMarkerDemo({
    this.direction = false,
    this.area = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) => direction
      ? Stack(
          alignment: Alignment.center,
          children: [
            SvgPicture.asset(
              Assets.icons.svg.mapControls.userPosition.path,
              package: packageName,
              fit: BoxFit.scaleDown,
            ),
            if (area)
              SvgPicture.asset(
                Assets.icons.svg.mapControls.backArea.path,
                package: packageName,
                fit: BoxFit.scaleDown,
              ),
          ],
        )
      : Stack(
          alignment: Alignment.center,
          children: [
            SvgPicture.asset(
              Assets.icons.svg.mapControls.userOnMap.path,
              package: packageName,
              fit: BoxFit.scaleDown,
            ),
            if (area)
              SvgPicture.asset(
                Assets.icons.svg.mapControls.backArea.path,
                package: packageName,
                fit: BoxFit.scaleDown,
              ),
          ],
        );
}
