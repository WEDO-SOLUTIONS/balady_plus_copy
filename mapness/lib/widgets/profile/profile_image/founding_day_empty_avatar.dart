import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

//TODO:(anyone) move to balady_uikit
class FoundingDayAvatar extends StatelessWidget {
  final double size;
  final String? abbreviatedName;
  const FoundingDayAvatar({required this.size, super.key, this.abbreviatedName});

  @override
  Widget build(BuildContext context) => SizedBox(
        width: size,
        height: size,
        child: DecoratedBox(
          decoration: BoxDecoration(shape: BoxShape.circle, gradient: getGradient(context)),
          child: ClipOval(
            child: _DataEmpty(size: size, abbreviatedName: abbreviatedName),
          ),
        ),
      );

  LinearGradient? getGradient(BuildContext context) => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [context.colors.accentDefault, const Color(0xff9E794B)],
        // colors: [],
      );
}

class _DataEmpty extends StatelessWidget {
  final String? abbreviatedName;
  final double size;

  const _DataEmpty({required this.size, this.abbreviatedName});

  @override
  Widget build(BuildContext context) {
    if (abbreviatedName == null || abbreviatedName!.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(size / 5),
        child: SvgPicture.asset(
          'assets/icons/ic_profile.svg',
          height: 36,
          width: 36,
          package: packageName,
          colorFilter: ColorFilter.mode(context.colors.backgroundSurface1, BlendMode.srcATop),
        ),
      );
    }
    return Center(
      child: Text(
        abbreviatedName!,
        style: context.textStyles.h1SemiBold.copyWith(color: context.colors.backgroundSurface1),
      ),
    );
  }
}
