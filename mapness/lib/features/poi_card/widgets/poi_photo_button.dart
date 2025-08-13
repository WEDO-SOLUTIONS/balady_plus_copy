import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/widgets.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/feedback/page_params/feedback_route_params.dart';
import 'package:mapness/features/poi_card/domain/dto/dgis_photos_dto.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class PoiPhotoButton extends StatelessWidget {
  final int objectId;
  final List<Item> photosItems;

  const PoiPhotoButton({
    required this.objectId,
    required this.photosItems,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (photosItems.isEmpty) {
      return const SizedBox.shrink();
    }

    return AppButton(
      buttonColorScheme: ButtonColorScheme.accent,
      buttonType: ButtonType.secondary,
      color: context.colors.backgroundSurface1,
      onTap: () => context.router.push(
        QuickFeedbackPhotoRoute(
          params: FeedbackObjectIdParams(objectId),
        ),
      ),
      size: ButtonSize.small,
      innerPadding: const EdgeInsetsDirectional.only(
        start: Spacing.$2x + Spacing.$0_5x,
        end: Spacing.$3x + Spacing.$0_5x,
      ),
      primaryIcon: General16Icons.photoSolid,
      primaryLabel: context.l10n.addPhoto,
      textColor: context.colors.accentDefault,
      iconColor: context.colors.accentDefault,
    );
  }
}
