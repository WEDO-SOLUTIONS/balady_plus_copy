part of 'package:balady_uikit/src/components/map_controls/map_controls.dart';

class WeatherControl extends StatelessWidget {
  final int? value;
  final VoidCallback? onTap;

  const WeatherControl({
    required this.value,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 28,
      width: 48,
      child: MapButton(
        onTap: onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              Assets.icons.svg.mapControls.icWeatherSun.path,
              package: packageName,
              colorFilter: onTap == null
                  ? ColorFilter.mode(context.colors.foregroundDisabled.withOpacity(0.5), BlendMode.srcIn)
                  : null,
            ),
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 1),
              child: Text(
                value != null ? '$value°' : '',
                textDirection: TextDirection.ltr,
                textAlign: TextAlign.center,
                style: context.textStyles.bodySmallMedium.copyWith(
                  color: onTap == null
                      ? context.colors.foregroundDisabled.withOpacity(0.5)
                      : context.colors.foregroundDefault,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
