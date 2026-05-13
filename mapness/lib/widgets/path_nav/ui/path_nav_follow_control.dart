import 'package:balady_uikit/core/colors/non_theme_colors.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/follow_state.dart';
import 'package:mapness/shared/ui/buttons/map_button.dart';

class PathNavFollowControl extends ConsumerWidget {
  const PathNavFollowControl({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final followState = ref.watch(followStateProvider);
    final iconColor = followState.type != LocationFollowType.off
        ? NonThemeColor.color30
        : context.colors.foregroundDefault;

    return MapButton(
      semanticsLabel: context.l10n.a11yFollowNavigation,
      onTap: () async {
        //BSA-1375: Fix the issue with the follow button. The button should work as expected in all types.
        final cameraPosition = ref.read(cameraPositionProvider);
        final dgisController = await ref.read(dgisControllerProvider.future);
        if (cameraPosition != null) {
          // Animate to the entrance
          await dgisController.setCameraPosition(
            CameraPositionMessage(
              point: cameraPosition.point,
              zoom: 18,
              tilt: cameraPosition.tilt,
              bearing: cameraPosition.tilt,
            ),
          );
        }
        await dgisController.followNavigation();
      },
      child: ExcludeSemantics(
        child: SvgPicture.asset(
          Assets.icons.svg.icControlLocation.keyName,
          colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
        ),
      ),
    );
  }
}
