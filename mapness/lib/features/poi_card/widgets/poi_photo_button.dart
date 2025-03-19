import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/widgets.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/feedback/page_params/feedback_route_params.dart';
import 'package:mapness/pages/feedback/quick_feedback_page.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class PoiPhotoButton extends StatefulWidget {
  final int objectId;

  const PoiPhotoButton({
    required this.objectId,
    super.key,
  });

  @override
  State<PoiPhotoButton> createState() => _PoiPhotoButtonState();
}

class _PoiPhotoButtonState extends State<PoiPhotoButton> {
  @override
  Widget build(BuildContext context) => AppButton(
        buttonColorScheme: ButtonColorScheme.onColor,
        onTap: () => context.router.push(
          QuickFeedbackRoute(
            type: QuickFeedbackType.addPhoto,
            params: FeedbackObjectIdParams(widget.objectId),
          ),
        ),
        size: ButtonSize.small,
        primaryIcon: General16Icons.photoSolid,
        primaryLabel: context.l10n.addPhoto,
        textColor: context.colorsV3.accentDefault,
        iconColor: context.colorsV3.accentDefault,
      );
}
