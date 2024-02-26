import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/app/routes/happines_map.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/lib/common_functions.dart';
import 'package:mapness/shared/ui/buttons/map_button.dart';

class HappinesControl extends ConsumerWidget {
  const HappinesControl({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MapButton(
      onTap: () => _openHappiness(context, ref),
      child: SvgPicture.asset(
        'assets/icons/svg/ic_like.svg',
        package: PackageConfig.packageName,
        colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
      ),
    );
  }

  Future<void> _openHappiness(BuildContext context, WidgetRef ref) async {
    await CommonFunctions.authOrOpen(context, callback: () {
      const HappinessMapRoute(bottomSheetOpened: false).push(context);
    },);
  }
}
