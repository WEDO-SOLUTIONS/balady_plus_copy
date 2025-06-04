import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/hooks/stateless_botomsheet_controller_hook.dart';

/// Base class for loading and error states
sealed class PoiLoadingOrError {
  const PoiLoadingOrError();
}

/// Loading state
class PoiLoading extends PoiLoadingOrError {
  const PoiLoading();
}

/// Error state
class PoiError extends PoiLoadingOrError {
  final String errorTitle;
  final String? errorContent;
  final String? buttonLabel;
  final VoidCallback? onRetry;
  final VoidCallback? onClose;

  const PoiError({
    required this.errorTitle,
    this.errorContent,
    this.buttonLabel,
    this.onRetry,
    this.onClose,
  });
}

/// Sheet for loading or error states. We combine loading and error states in one sheet to avoid code duplication and
/// additional call of the same sheet. We prevent "jumps" of the sheet when we switch between loading and error states.
class PoiLoadingOrErrorSheet extends HookConsumerWidget {
  /// Height of the sheet
  final double sheetHeight;

  /// Height of the content
  final double contentHeight;

  /// ObjectId to show loading or error
  final DgisObjectIdMessage objectId;

  /// Data to show loading or error
  final PoiLoadingOrError data;

  const PoiLoadingOrErrorSheet({
    required this.objectId,
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
      heightModel: BottomSheetHeightModel.fixed(sheetHeight),
    );
    return StatelessBottomSheet(
      scrollController: scrollController,
      content: [
        Stack(
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
            SizedBox(
              height: contentHeight,
              child: switch (data) {
                PoiLoading() => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Loading.large(),
                        ],
                      ),
                    ],
                  ),
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
                          const SizedBox(height: Spacing.$6x),
                          BaladyAppButton(
                            onTap: error.onRetry ?? () {},
                            buttonColorScheme: BaladyButtonColorScheme.accentSecondary,
                            size: BaladyButtonSize.large,
                            primaryLabel: error.buttonLabel ?? context.l10n.tryAgain,
                          ),
                        ],
                      ),
                    );
                  }),
              },
            ),
          ],
        ),
      ],
    );
  }
}
