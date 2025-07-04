import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/features/poi_card/domain/model/loading_or_failure_model.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/hooks/stateless_botomsheet_controller_hook.dart';
import 'package:mapness/shared/ui/safe_area_padding.dart';

/// Sheet for loading or error states. We combine loading and error states in one sheet to avoid code duplication and
/// additional call of the same sheet. We prevent "jumps" of the sheet when we switch between loading and error states.
class PoiLoadingOrErrorSheet extends HookConsumerWidget {
  /// Height of the sheet
  final double sheetHeight;

  /// Height of the content
  final double contentHeight;

  /// Data to show loading or error
  final PoiLoadingOrError data;

  const PoiLoadingOrErrorSheet({
    required this.data,
    required this.sheetHeight,
    required this.contentHeight,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onClose = () {
      if (data is PoiError && (data as PoiError).onClose != null) {
        (data as PoiError).onClose!.call();
      } else {
        context.router.popForced();
      }
    };
    final scrollController = useStatelessBottomsheetController(
      onClose: (_) {
        onClose();
      },
      heightModel: BottomSheetHeightModel.aspect(0.4),
    );
    return SafeAreaPadding(
      child: StatelessBottomSheet(
        scrollController: scrollController,
        sliverBeforeContent: SliverFillRemaining(
          child: Stack(
            children: [
              Align(
                alignment: AlignmentDirectional.topEnd,
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(end: Spacing.$4x),
                  child: BaladyAppButton.close(
                    buttonType: BaladyButtonType.secondary,
                    onTap: onClose,
                  ),
                ),
              ),
              switch (data) {
                PoiLoading() => Center(child: Loading.large()),
                PoiError() => Builder(builder: (context) {
                    final error = data as PoiError;
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
                          SvgPicture.asset(Assets.imagesSvg.illustrationError.keyName),
                          const SizedBox(height: Spacing.$4x),
                          Text(
                            error.errorTitle,
                            textAlign: TextAlign.center,
                            style: context.textStyleV3.h3SemiBold.copyWith(
                              color: context.colorsV2.foregroundDefault,
                            ),
                          ),
                          if (error.errorContent != null)
                            Padding(
                              padding: const EdgeInsets.only(top: Spacing.$2x),
                              child: Text(
                                error.errorContent ?? '',
                                textAlign: TextAlign.center,
                                style: context.textStyleV3.bodyLargeRegular.copyWith(
                                  color: context.colorsV2.foregroundSoft,
                                ),
                              ),
                            ),
                          Spacing.$6x.heightBox,
                          BaladyAppButton(
                            onTap: error.onRetry,
                            buttonColorScheme: BaladyButtonColorScheme.accentSecondary,
                            size: BaladyButtonSize.large,
                            primaryLabel: error.buttonLabel ?? context.l10n.tryAgain,
                          ),
                        ],
                      ),
                    );
                  }),
              },
            ],
          ),
        ),
      ),
    );
  }
}
