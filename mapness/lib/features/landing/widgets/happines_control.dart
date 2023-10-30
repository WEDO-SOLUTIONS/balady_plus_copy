import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/features/common/config/package_config.dart';
import 'package:mapness/features/landing/providers/map_controls.dart';
import 'package:mapness/features/landing/widgets/map_control.dart';

class HappinesControl extends ConsumerWidget {
  const HappinesControl({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MapControl(
      onTap: () {
        ref
            .read(mapControlsProvider.notifier)
            .update(MapControlsStateHappinessMap());
      },
      child: SvgPicture.asset(
        "assets/icons/svg/ic_like.svg",
        package: PackageConfig.packageName,
        colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
      ),
    );
  }
}
