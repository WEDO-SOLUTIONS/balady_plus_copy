import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:urbi_utils/urbi_utils.dart';

class TableStyles extends StatelessWidget {
  const TableStyles({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _stateColumn(context),
        const SizedBox(width: 20),
        _squareColumn(context),
        const SizedBox(width: 20),
        _circleColumn(context),
        const SizedBox(width: 20),
        _weatherColumn(context),
        const SizedBox(width: 20),
        _trafficColumn(context),
        const SizedBox(width: 20),
        _locColumn(context),
      ],
    );
  }

  Widget _stateColumn(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 26,
          child: Text(
            '',
            style: context.textStyles.bodyLargeRegular.copyWith(
              color: context.colors.accentDefault,
            ),
          ),
        ),
        SizedBox(
          height: 48,
          child: Text(
            'Default',
            style: context.textStyles.bodyLargeRegular.copyWith(
              color: context.colors.accentDefault,
            ),
          ),
        ),
        SizedBox(
          height: 48,
          child: Text(
            'Active',
            style: context.textStyles.bodyLargeRegular.copyWith(
              color: context.colors.accentDefault,
            ),
          ),
        ),
        SizedBox(
          height: 48,
          child: Text(
            'Disable',
            style: context.textStyles.bodyLargeRegular.copyWith(
              color: context.colors.accentDefault,
            ),
          ),
        ),
        const SizedBox(height: 20),
      ].insertBetween(const SizedBox(height: 12)).toList(),
    );
  }

  Widget _squareColumn(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          'Square',
          style: context.textStyles.bodyLargeRegular.copyWith(
            color: context.colors.accentDefault,
          ),
        ),
        MapButton(
          onTap: () {},
          child: const Icon(GeneralIcons.placeholder),
        ),
        MapButton(
          onTap: () {},
          child: const Icon(GeneralIcons.placeholder),
        ),
        MapButton(
          child: Icon(
            GeneralIcons.placeholder,
            color: context.colors.foregroundDisabled,
          ),
        ),
        const SizedBox(height: 20),
      ].insertBetween(const SizedBox(height: 12)).toList(),
    );
  }

  Widget _circleColumn(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          'Circle',
          style: context.textStyles.bodyLargeRegular.copyWith(
            color: context.colors.accentDefault,
          ),
        ),
        CompassControl(
          angle: 0,
          opacity: 1,
          onTap: () {},
        ),
        CompassControl(
          angle: 0,
          opacity: 1,
          onTap: () {},
        ),
        const CompassControl(
          angle: 0,
          opacity: 1,
        ),
        const SizedBox(height: 20),
      ].insertBetween(const SizedBox(height: 12)).toList(),
    );
  }

  Widget _weatherColumn(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          'Weather',
          style: context.textStyles.bodyLargeRegular.copyWith(color: context.colors.accentDefault),
        ),
        WeatherControl(
          onTap: () {},
          value: 53,
        ),
        WeatherControl(
          onTap: () {},
          value: 53,
        ),
        const WeatherControl(value: 53),
        const SizedBox(height: 20),
      ].insertBetween(const SizedBox(height: 12)).toList(),
    );
  }

  Widget _trafficColumn(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          'Traffic',
          style: context.textStyles.bodyLargeRegular.copyWith(
            color: context.colors.accentDefault,
          ),
        ),
        TrafficControl(
          opacity: 1,
          isEnabled: false,
          onTap: () {},
        ),
        TrafficControl(
          opacity: 1,
          isEnabled: true,
          onTap: () {},
        ),
        const TrafficControl(opacity: 1, isEnabled: false),
        const SizedBox(height: 20),
      ].insertBetween(const SizedBox(height: 12)).toList(),
    );
  }

  Widget _locColumn(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          'Loc',
          style: context.textStyles.bodyLargeRegular.copyWith(
            color: context.colors.accentDefault,
          ),
        ),
        FollowControl(
          opacity: 1,
          onTap: () {},
        ),
        FollowControl(
          opacity: 1,
          isDriving: true,
          onTap: () {},
        ),
        const FollowControl(opacity: 1),
        const SizedBox(height: 20),
      ].insertBetween(const SizedBox(height: 12)).toList(),
    );
  }
}
