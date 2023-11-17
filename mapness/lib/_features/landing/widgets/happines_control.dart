import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/app/routes/happines_map.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/ui/buttons/map_button.dart';

class HappinesControl extends ConsumerWidget {
  const HappinesControl({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MapButton(
      onTap: () {
        // ref
        //     .read(mapControlsProvider.notifier)
        //     .update(MapControlsStateHappinessMap());
        const HappinessMapRoute().push(context);
      },
      child: SvgPicture.asset(
        "assets/icons/svg/ic_like.svg",
        package: PackageConfig.packageName,
        colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
      ),
    );
  }
}
