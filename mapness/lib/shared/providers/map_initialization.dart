import 'package:dgis_map/library.dart';
import 'package:mapness/features/routing/providers/routes.dart';
import 'package:mapness/shared/constants/constants.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/dark_mode.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'map_initialization.g.dart';

@riverpod
class _MapInitialization extends _$MapInitialization {
  @override
  Future<InitializeMessage> build({required DgisMapController controller}) async {
    final initialize = await controller.initialize();
    //Styles
    await controller.loadStyles(MapnessConstants.mapStylesPath);

    // Appearance
    await controller.setZoomRestrictions(min: 5.5);
    await controller.overrideLocales(ref.read(appLanguageProvider) == Language.arabic ? ['ar-SA'] : ['en-SA']);
    await controller.setAppearance(
      (await ref.read(darkModeProvider.future)).isDark ? MapAppearanceMessage.night : MapAppearanceMessage.day,
    );
    await controller.setBetterRouteSettings(BetterRouteSettings.prod);

    return initialize;
  }
}

const mapInitializationProvider = _mapInitializationProvider;
