import 'package:balady_uikit/balady_uikit.dart' hide MapButton;
import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/features/special_themes/modes/saudi_national_day/saudi_national_day.dart';
import 'package:mapness/entities/city_event/city_event.dart';
import 'package:mapness/features/city_event/active_city_event.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/dark_mode.dart';
import 'package:mapness/shared/ui/buttons/map_button.dart';

class TrafficControlWidget extends ConsumerWidget {
  final double opacity;
  final bool isEnabled;
  final BorderRadius? borderRadius;
  final Function()? onTap;

  const TrafficControlWidget({
    required this.opacity,
    required this.isEnabled,
    this.borderRadius,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => AnimatedOpacity(
    opacity: opacity,
    duration: const Duration(milliseconds: 250),
    child: MapButton(
      borderRadius: borderRadius,
      onTap: onTap,
      semanticsLabel: context.l10n.layersTraffic,
      child: SizedBox(
        width: 24,
        height: 24,
        child: ref
            .read(activeCityEventProvider)
            .trafficIcon(
              isDark: ref.watch(darkModeProvider).value?.isDark ?? false,
              isOn: isEnabled,
            ),
      ),
    ),
  );
}
