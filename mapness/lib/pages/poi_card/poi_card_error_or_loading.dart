import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/features/city_event/active_city_event.dart';
import 'package:mapness/features/poi_card/domain/model/loading_or_failure_model.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/hooks/toggle_sheet_controller_hook.dart';
import 'package:mapness/shared/providers/regular_poi_active.dart';
import 'package:mapness/shared/ui/error_widget/base_error_widget.dart';
import 'package:sheetify/sheetify.dart';

import '../../shared/providers/map/selected_marker.dart';

/// Sheet for loading or error states. We combine loading and error states in one sheet to avoid code duplication and
/// additional call of the same sheet. We prevent "jumps" of the sheet when we switch between loading and error states.
class PoiLoadingOrErrorSheet extends HookConsumerWidget {
  /// Height of the sheet
  final double sheetHeight;

  /// Data to show loading or error
  final PoiLoadingOrError data;

  const PoiLoadingOrErrorSheet({required this.data, required this.sheetHeight, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onClose = () {
      ref.read(regularPoiActiveProvider.notifier).setActive(false);
      if (data is PoiError && (data as PoiError).onClose != null) {
        (data as PoiError).onClose!.call();
      } else {
        ref.read(selectedMarkerProvider.notifier).removeAllMarkers();
        context.router.pop();
      }
    };
    final scrollController = useToggleSheetController(
      onClose: (_) {
        onClose();
      },
      heightModel: ToggleSheetHeightModel.fraction(0.42),
    );

    final activeEvent = ref.watch(activeCityEventProvider);

    return ToggleSheet(
      scrollController: scrollController,
      backgroundColor: context.colors.backgroundSurface2,
      safeAreaColor: context.colors.backgroundSurface2,
      dragger: const SheetDragger(),
      sliver: SliverFillRemaining(
        child: Stack(
          children: [
            Align(
              alignment: AlignmentDirectional.topEnd,
              child: Padding(
                padding: const EdgeInsetsDirectional.only(end: Spacing.$4x),
                child: AppButton.close(onTap: onClose),
              ),
            ),
            switch (data) {
              PoiLoading() => Center(child: Loading.large()),
              PoiError(:final errorTitle, :final errorContent, :final onRetry, :final buttonLabel) => Builder(
                builder: (context) {
                  final padding = MediaQuery.of(context).padding;
                  double bottomPadding = Spacing.$4x;
                  if (padding.bottom > 0) {
                    bottomPadding = Spacing.$1x;
                  }
                  return Padding(
                    padding: EdgeInsets.only(
                      top: Spacing.$4x,
                      left: Spacing.$4x,
                      right: Spacing.$4x,
                      bottom: bottomPadding,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Flexible(child: FittedBox(child: const ErrorImageWidget())),
                        const SizedBox(height: Spacing.$4x),
                        Text(
                          errorTitle,
                          textAlign: TextAlign.center,
                          style: context.textStyles.h3SemiBold.copyWith(color: context.colors.foregroundDefault),
                        ),
                        if (errorContent != null)
                          Padding(
                            padding: const EdgeInsets.only(top: Spacing.$2x),
                            child: Text(
                              errorContent,
                              textAlign: TextAlign.center,
                              style: context.textStyles.bodyLargeRegular.copyWith(color: context.colors.foregroundSoft),
                            ),
                          ),
                        Spacing.$6x.heightBox,
                        AppButton(
                          onTap: onRetry,
                          buttonColorScheme: ButtonColorScheme.accentSecondary,
                          size: ButtonSize.large,
                          primaryLabel: buttonLabel ?? context.l10n.tryAgain,
                        ),
                      ],
                    ),
                  );
                },
              ),
            },
          ],
        ),
      ),
    );
  }
}
