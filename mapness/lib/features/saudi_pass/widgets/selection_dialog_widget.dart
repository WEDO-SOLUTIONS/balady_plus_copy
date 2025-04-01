import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/widgets/decorated_smooth_radius.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mapness/features/saudi_pass/views/selection_dialog.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/ui/buttons/app_close_button.dart';

class SelectionDialogWidget<T> extends StatefulWidget {
  final SelectionDialog<T> selectionDialog;
  final String title;
  final Widget Function(Iterable<SelectionView<T>> views) layoutBuilder;
  final Color? backgroundColor;

  const SelectionDialogWidget({
    required this.selectionDialog,
    required this.title,
    required this.layoutBuilder,
    this.backgroundColor,
    super.key,
  });

  @override
  State<SelectionDialogWidget> createState() => _SelectionDialogWidgetState<T>();
}

class _SelectionDialogWidgetState<T> extends State<SelectionDialogWidget<T>> {
  late final scrollController = StatelessBottomSheetController(
    onClose: (_) => widget.selectionDialog.tapCross(),
  );

  SelectionDialog<T> get selectionDialog => widget.selectionDialog;

  @override
  Widget build(BuildContext context) {
    const horizontalPadding = EdgeInsets.symmetric(horizontal: Spacing.$4x);

    return StatelessBottomSheet(
      scrollController: scrollController,
      backgroundColor: widget.backgroundColor,
      draggerColor: widget.backgroundColor,
      header: Padding(
        padding: horizontalPadding.copyWith(bottom: Spacing.$4x),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.title, style: context.textStyleV3.h2SemiBold),
            CustomCloseButton(onClose: widget.selectionDialog.tapCross),
          ],
        ),
      ),
      content: [
        Padding(
          padding: horizontalPadding,
          child: ListenableBuilder(
            listenable: selectionDialog,
            builder: (context, _) => widget.layoutBuilder(selectionDialog.selectionViews),
          ),
        ),
      ],
      footer: Padding(
        padding: horizontalPadding.copyWith(bottom: Spacing.$4x, top: Spacing.$6x),
        child: ResetSaveWidget(selectionDialog),
      ),
    );
  }
}

class ResetSaveWidget extends StatelessWidget {
  final ResetSaveView resetSaveView;

  const ResetSaveWidget(this.resetSaveView, {super.key});

  @override
  Widget build(BuildContext context) {
    final resetButton = BaladyAppButton(
      primaryLabel: context.l10n.saudiPassDialogReset,
      onTap: resetSaveView.tapReset,
      size: BaladyButtonSize.large,
      buttonColorScheme: BaladyButtonColorScheme.accentSecondary,
      buttonType: BaladyButtonType.secondary,
    );

    final saveButton = BaladyAppButton(
      primaryLabel: context.l10n.saudiPassDialogSave,
      onTap: resetSaveView.tapSave,
      size: BaladyButtonSize.large,
      buttonColorScheme: BaladyButtonColorScheme.accentSecondary,
    );

    return Row(
      children: [
        Expanded(child: resetButton),
        const SizedBox(width: Spacing.$2x),
        Expanded(child: saveButton),
      ],
    );
  }
}

class WrapLayout extends StatelessWidget {
  final Iterable<SelectionView<String>> selectionViews;

  const WrapLayout(this.selectionViews, {super.key});

  @override
  Widget build(BuildContext context) => Wrap(
        spacing: Spacing.$2x,
        runSpacing: Spacing.$2x,
        children: selectionViews.map(StringItemViewWidget.new).toList(),
      );
}

class ContentRowLayout extends StatelessWidget {
  final Iterable<SelectionView<Sorting>> selectionViews;

  const ContentRowLayout(this.selectionViews, {super.key});

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(RadiusBorder.ml)),
        child: Column(
          children: selectionViews
              .mapIndexed((index, view) => SortingItemViewWidget(view, hasDivider: index < selectionViews.length - 1))
              .toList(),
        ),
      );
}

class StringItemViewWidget extends StatelessWidget {
  final SelectionView<String> view;

  const StringItemViewWidget(this.view, {super.key});

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: view,
        builder: (context, _) {
          final colorsV2 = context.colorsV3;
          final textColor = view.isHighlighted ? colorsV2.accentOnAccent : colorsV2.foregroundDefault;

          return DecoratedSmoothRadius(
            borderRadius: RadiusBorder.m,
            color: view.isHighlighted ? colorsV2.accentSecondaryDefault : colorsV2.neutralContainerDefault,
            child: InkWell(
              splashFactory: NoSplash.splashFactory,
              splashColor: context.color.surfaceOverlayPressed,
              onTap: view.onTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Spacing.$3x),
                child: SizedBox(
                  height: AppSizes.xs,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        view.title,
                        textHeightBehavior: TextHeightBehavior(
                          applyHeightToLastDescent: Directionality.of(context) == TextDirection.ltr,
                        ),
                        style: context.textStyleV3.bodySmallMedium.copyWith(color: textColor),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
}

class SortingItemViewWidget extends StatelessWidget {
  final SelectionView<Sorting> view;
  final bool hasDivider;

  const SortingItemViewWidget(this.view, {this.hasDivider = true, super.key});

  @override
  Widget build(BuildContext context) {
    const checkmark = Padding(
      padding: EdgeInsetsDirectional.only(end: Spacing.$4x),
      child: Icon(SystemIcons.checkmark),
    );

    const nothing = SizedBox.shrink();

    final trailing = ContentRowCustomTrailingOptions(builder: (context) => view.isHighlighted ? checkmark : nothing);

    return ListenableBuilder(
      listenable: view,
      builder: (context, _) => SizedBox(
        height: AppSizes.l,
        child: ContentRowV2(
          leading: nothing,
          text: ContentRowTextOptions(
            title: switch (view.title) {
              Sorting.byRecency => context.l10n.saudiPassSortingByRecency,
              Sorting.byRating => context.l10n.saudiPassSortingByRating
            },
          ),
          onTap: view.onTap,
          isDividerEnabled: hasDivider,
          supportTitleRTL: true,
          backgroundColor: context.colorsV3.backgroundSurface1,
          trailing: trailing,
        ),
      ),
    );
  }
}
