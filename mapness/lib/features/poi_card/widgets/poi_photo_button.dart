import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/widgets.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/feedback/page_params/feedback_route_params.dart';
import 'package:mapness/features/poi_card/enums/poi_card_bottom_sheet_state.dart';
import 'package:mapness/features/poi_card/enums/poi_tabs_type.dart';
import 'package:mapness/features/poi_card/widgets/footer/poi_card_footer.dart';
import 'package:mapness/pages/feedback/quick_feedback_page.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class PoiPhotoButton extends StatefulWidget {
  final bool isPhotosNotEmpty;
  final ValueNotifier<PoiTabsType> tabType;
  final int objectId;
  final StatefulBottomSheetController<PoiCardBottomSheetState> controller;

  const PoiPhotoButton({
    required this.isPhotosNotEmpty,
    required this.tabType,
    required this.objectId,
    required this.controller,
    super.key,
  });

  @override
  State<PoiPhotoButton> createState() => _PoiPhotoButtonState();
}

class _PoiPhotoButtonState extends State<PoiPhotoButton> {
  late final ValueNotifier<PoiCardBottomSheetState> _stateNotifier;

  @override
  void initState() {
    _stateNotifier = ValueNotifier(widget.controller.state);

    widget.controller.addListener(() {
      _stateNotifier.value = widget.controller.closestState;
    });
    super.initState();
  }

  @override
  void dispose() {
    _stateNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ValueListenableBuilder(
        valueListenable: _stateNotifier,
        builder: (context, state, _) => ValueListenableBuilder(
          valueListenable: widget.tabType,
          builder: (context, tabType, _) {
            if (tabType != PoiTabsType.photos || widget.isPhotosNotEmpty) {
              return const SizedBox.shrink();
            }

            if (state == PoiCardBottomSheetState.hidden || state == PoiCardBottomSheetState.halfOpen) {
              return const SizedBox.shrink();
            }

            return Positioned.directional(
              end: Spacing.$3x,
              bottom: Spacing.$2x,
              textDirection: Directionality.of(context),
              child: Container(
                padding: const EdgeInsets.only(bottom: PoiCardFooter.height + 2 * PoiCardFooter.padding),
                alignment: AlignmentDirectional.bottomEnd,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 132),
                  child: AppButton(
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
                  ),
                ),
              ),
            );
          },
        ),
      );
}
