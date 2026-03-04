part of 'package:balady_uikit/src/components/map_controls/map_controls.dart';

class MapPin extends StatelessWidget {
  final IconData iconData;

  const MapPin({
    required this.iconData,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          SvgPicture.asset(
            Assets.icons.svg.mapControls.icPin.path,
            package: packageName,
            fit: BoxFit.cover,
          ),
          Positioned(
            bottom: 15,
            left: 8,
            right: 8,
            child: Icon(
              iconData,
              color: context.colors.staticWhite,
            ),
          ),
        ],
      );
}
