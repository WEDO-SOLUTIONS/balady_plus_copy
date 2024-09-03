import 'package:balady_uikit/core/colors/non_theme_colors.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/follow_state.dart';

import 'package:mapness/shared/ui/buttons/map_button.dart';

class PathNavFollowControl extends ConsumerWidget {
  const PathNavFollowControl({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final followState = ref.watch(followStateProvider);
    final iconColor = followState.type != LocationFollowType.off ? NonThemeColor.color30 : Colors.black;

    return AnimatedOpacity(
      opacity: followState.enabled ? 1 : 1, // fix
      duration: const Duration(milliseconds: 250),
      child: MapButton(
        onTap: () async {
          switch (followState.type) {
            case LocationFollowType.followPosition:
              return;
            case LocationFollowType.off || LocationFollowType.followDirection:
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
          }
        },
        child: SvgPicture.asset(
          'assets/icons/svg/ic_control_location.svg',
          semanticsLabel: 'MinApps Screen',
          package: 'mapness',
          colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
        ),
      ),
    );
  }
}
