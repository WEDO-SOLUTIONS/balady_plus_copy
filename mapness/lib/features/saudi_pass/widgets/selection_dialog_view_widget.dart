import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mapness/features/saudi_pass/views/selection_dialog_view.dart';
import 'package:mapness/features/saudi_pass/widgets/reset_save_widget.dart';
import 'package:mapness/features/saudi_pass/widgets/small_chip_widget.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/hooks/toggle_sheet_controller_hook.dart';
import 'package:mapness/shared/ui/buttons/app_close_button.dart';
import 'package:sheetify/toggle_sheet/toggle_sheet.dart';

class SelectionDialogViewWidget<T> extends HookWidget {
  final SelectionDialogView<T> selectionDialogView;
  final String title;
  final Widget Function(Iterable<SelectionView<T>> views) layoutBuilder;
  final Color? backgroundColor;

  const SelectionDialogViewWidget({
    required this.selectionDialogView,
    required this.title,
    required this.layoutBuilder,
    this.backgroundColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final scrollController = useToggleSheetController(
        onClose: (_) => selectionDialogView.tapCross(context));

    const horizontalPadding = EdgeInsets.symmetric(horizontal: Spacing.$4x);

    return ToggleSheet(
      scrollController: scrollController,
      backgroundColor: backgroundColor ?? context.colors.backgroundSurface2,
      safeAreaColor: backgroundColor ?? context.colors.backgroundSurface2,
      outside: GestureDetector(
        onTap: context.router.popForced,
      ),
      header: Padding(
        padding: horizontalPadding.copyWith(bottom: Spacing.$4x),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: context.textStyles.h2SemiBold),
            CustomCloseButton(
              onClose: () => selectionDialogView.tapCross(context),
            ),
          ],
        ),
      ),
      content: [
        Padding(
          padding: horizontalPadding,
          child: ListenableBuilder(
            listenable: selectionDialogView,
            builder: (context, _) =>
                layoutBuilder(selectionDialogView.selectionViews),
          ),
        ),
        Padding(
          padding: horizontalPadding.copyWith(
            top: Spacing.$6x,
            bottom: Spacing.$4x + MediaQuery.viewPaddingOf(context).bottom,
          ),
          child: ResetSaveWidget(selectionDialogView),
        ),
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
              .mapIndexed(
                (index, view) => ListenableBuilder(
                  listenable: Listenable.merge(selectionViews),
                  builder: (_, __) => SortingItemViewWidget(
                    view,
                    hasDivider: index < selectionViews.length - 1,
                  ),
                ),
              )
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
        builder: (context, _) => SmallChipWidget(
          title: view.title,
          isHighlighted: view.isHighlighted,
          onTap: () => view.onTap(context),
        ),
      );
}

class SortingItemViewWidget extends StatelessWidget {
  final SelectionView<Sorting> view;
  final bool hasDivider;

  const SortingItemViewWidget(this.view, {this.hasDivider = true, super.key});

  @override
  Widget build(BuildContext context) {
    const nothing = SizedBox.shrink();

    return ListenableBuilder(
      listenable: view,
      builder: (context, _) => SizedBox(
        height: AppSizes.l,
        child: ContentRow(
          leading: nothing,
          text: ContentRowTextOptions(
            title: switch (view.title) {
              Sorting.byRecency => context.l10n.saudiPassSortingByRecency,
              Sorting.byRating => context.l10n.saudiPassSortingByRating
            },
          ),
          onTap: () => view.onTap(context),
          isDividerEnabled: hasDivider,
          supportTitleRTL: true,
          backgroundColor: context.colors.backgroundSurface1,
          trailing: ContentRowCustomTrailingOptions(
            builder: (context) => view.isHighlighted
                ? const Padding(
                    padding: EdgeInsetsDirectional.only(end: Spacing.$4x),
                    child: Icon(SystemIcons.checkmark),
                  )
                : nothing,
          ),
        ),
      ),
    );
  }
}
