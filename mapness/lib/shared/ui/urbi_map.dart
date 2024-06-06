import 'package:dgis_map/library.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/routing/providers/routes.dart';
import 'package:mapness/shared/providers/dark_mode.dart';

import '../providers/app_language.dart';

class UrbiMap extends ConsumerWidget {
  const UrbiMap({
    required this.onMapCreated,
    this.androidUseExpensive = false,
    super.key,
  });

  final Function(DgisMapController controller) onMapCreated;
  final bool androidUseExpensive;

  @override
  Widget build(BuildContext context, WidgetRef ref) => DgisMap(
        key: key,
        androidUseExpensive: androidUseExpensive,
        onMapCreated: (controller) async {
          await controller.initialize();

          // Styles
          await controller.loadStyles('assets/maps/styles/common-styles.2gis');

          // Appearance
          await controller.setZoomRestrictions(
            min: 5.5,
          );
          await controller.overrideLocales(
            ref.read(appLanguageProvider) == Language.arabic ? ['ar-SA'] : ['en-SA'],
          );
          await controller.setAppearance(
            ref.read(darkModeProvider) ? MapAppearanceMessage.night : MapAppearanceMessage.day,
          );
          await controller.setBetterRouteSettings(BetterRouteSettings.prod);

          onMapCreated(controller);
        },
      );
}
