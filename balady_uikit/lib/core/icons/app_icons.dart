import 'package:balady_uikit/core/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

///https://www.figma.com/file/owbsr9Pf0mQSEHXlbiPGOv/Balady-%E2%80%93-Components-Library?type=design&node-id=1763-22890&mode=design&t=SDHK3kmgGjetLldc-4
class AppIcons extends StatelessWidget {
  final IconData? iconData;
  final Color? color;
  final String? iconPath;
  final double? size;
  final String package;

  const AppIcons({
    this.iconData,
    super.key,
    this.color,
    this.iconPath,
    this.size,
    this.package = packageName,
  });

  @override
  Widget build(BuildContext context) {
    final iconPathUnwrapped = iconPath;
    if (iconPathUnwrapped != null) {
      return SvgPicture.asset(
        iconPathUnwrapped,
        package: package,
      );
    }
    final iconDataUnwrapped = iconData;
    if (iconDataUnwrapped != null) {
      return Icon(
        iconData,
        color: color,
        size: size,
      );
    }

    return const SizedBox.shrink();
  }
}
