import 'package:auto_route/auto_route.dart';
import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mapness/features/saudi_pass/functions/get_category_svg.dart';
import 'package:mapness/features/saudi_pass/functions/get_highlighted_text_spans.dart';
import 'package:mapness/features/saudi_pass/notifiers/category_selection_dialog_view_notifier.dart';
import 'package:mapness/features/saudi_pass/repo/lookups_body.dart';
import 'package:mapness/features/saudi_pass/views/selection_dialog_view.dart';
import 'package:mapness/features/saudi_pass/widgets/reset_save_widget.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/hooks/toggle_sheet_controller_hook.dart';
import 'package:mapness/shared/ui/buttons/app_close_button.dart';
import 'package:sheetify/sheetify.dart';

class AllCategoriesSelectionDialogViewWidget extends HookWidget {
  final CategorySelectionDialogViewNotifier selectionDialogView;

  const AllCategoriesSelectionDialogViewWidget(
    this.selectionDialogView, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final scrollController = useToggleSheetController(
      onClose: (_) => context.router.pop(),
      heightModel: ToggleSheetHeightModel.fraction(0.99),
    );

    final textEditingController = useTextEditingController();

    useListenable(textEditingController);

    useEffect(() {
      selectionDialogView.onSearchInput(textEditingController.text);
      return null;
    }, [textEditingController.text]);

    const horizontalPadding = EdgeInsets.symmetric(horizontal: Spacing.$4x);

    return SafeArea(
      bottom: false,
      child: ToggleSheet(
        barrierColorDelegate: ToggleSheetDelegateFunction<Color?>(
          function: (controller) => AppColor.black.withOpacity(
            0.4 * (1 - controller.interpolation),
          ),
        ),
        dragger: DraggerContainer(
          backgroundColor: context.colors.backgroundSurface1,
        ),
        backgroundColor: context.colors.backgroundSurface5,
        safeAreaColor: context.colors.backgroundSurface5,
        scrollController: scrollController,
        header: Container(
          color: context.colors.backgroundSurface1,
          padding: horizontalPadding.copyWith(bottom: Spacing.$4x),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.l10n.saudiPassOffersPageFilterCategory,
                style: context.textStyles.h2SemiBold,
              ),
              CustomCloseButton(
                onClose: () => selectionDialogView.tapCross(context),
              ),
            ],
          ),
        ),
        sliver: SliverFillRemaining(
          child: ListenableBuilder(
              listenable: selectionDialogView,
              builder: (context, _) {
                final notingFound = selectionDialogView.nothingFound;
                final search = selectionDialogView.search;
                final group = selectionDialogView.groupedViews
                  ..removeWhere(
                    (cat, views) => views.isEmpty,
                  );

                return Column(
                  children: [
                    Container(
                        padding:
                            horizontalPadding.copyWith(bottom: Spacing.$4x),
                        decoration: BoxDecoration(
                          color: context.colors.backgroundSurface1,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(RadiusBorder.xl),
                            bottomRight: Radius.circular(RadiusBorder.xl),
                          ),
                        ),
                        child: BaladyTextInput(
                          config: BaladyInputConfig(
                            fillColor: context.colors.backgroundSurface5,
                            autofocus: true,
                            hintColor: context.colors.foregroundMuted,
                            hintText: context
                                .l10n.saudiPassCategorySelectionPageSearchHint,
                            isDisposed: false,
                          ),
                          controller: textEditingController,
                          inputState: notingFound
                              ? BaladyInputState.error
                              : BaladyInputState.defaultValue,
                          supportingText: notingFound
                              ? BaladySupportingText(
                                  text: context.l10n
                                      .noResultsFoundPleaseSelectFromTheList,
                                )
                              : null,
                        )),
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: group.length,
                        itemBuilder: (context, index) {
                          final entry = group.entries.elementAt(index);
                          final category = entry.key;
                          final subViews = entry.value;

                          final bool isSearchingCategory = category.name
                              .toLowerCase()
                              .contains(search.toLowerCase());
                          return Column(
                            children: [
                              if (isSearchingCategory || notingFound) ...[
                                CategoryHeader(
                                  category: category,
                                  onTap: (id) =>
                                      selectionDialogView.toggleCategory(
                                    categoryId: id,
                                    context: context,
                                  ),
                                  isHighlighted: subViews.every(
                                    (view) => view.isHighlighted,
                                  ),
                                ),
                                CategoriesCard(
                                  child: SubCategoriesWidget(
                                    selectionViews: subViews,
                                  ),
                                ),
                              ] else
                                SubCategoriesWidget(
                                  selectionViews: subViews,
                                  categoryId: category.id,
                                  search: search,
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                );
              }),
        ),
        footer: ColoredBox(
          color: context.colors.backgroundSurface5,
          child: Padding(
            padding: horizontalPadding.copyWith(
              top: Spacing.$6x,
              bottom: Spacing.$4x + MediaQuery.viewPaddingOf(context).bottom,
            ),
            child: ResetSaveWidget(selectionDialogView),
          ),
        ),
      ),
    );
  }
}

class CategoryHeader extends StatelessWidget {
  const CategoryHeader({
    required this.category,
    required this.onTap,
    required this.isHighlighted,
    super.key,
  });

  final Category category;
  final ValueChanged<String> onTap;
  final bool isHighlighted;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsetsDirectional.only(
          top: Spacing.$2x,
          bottom: Spacing.$2x,
          end: Spacing.$8x,
        ),
        child: ContentRow(
          key: ValueKey<bool>(isHighlighted),
          leading: getCategorySvg(category.id),
          onTap: () => onTap(category.id),
          text: ContentRowTextOptions(
            titleOptions: ContentRowTextOption(
              builder: (context) => Text(
                category.name,
                style: context.textStyles.captionLargeMedium.copyWith(
                  color: context.colors.foregroundSoft,
                ),
              ),
            ),
          ),
          supportTitleRTL: true,
          trailing: ContentRowCustomTrailingOptions(
            builder: (context) => BaladyCheckBox(
              state: isHighlighted
                  ? BaladyCheckBoxState.checked
                  : BaladyCheckBoxState.unchecked,
              disable: false,
              onChanged: (_) => onTap(category.id),
            ),
          ),
        ),
      );
}

class SubCategoriesWidget extends StatelessWidget {
  const SubCategoriesWidget({
    required this.selectionViews,
    this.categoryId,
    this.search,
    super.key,
  });
  final List<SelectionView<String>> selectionViews;
  final String? categoryId;
  final String? search;

  @override
  Widget build(BuildContext context) => Column(
        children: selectionViews
            .mapIndexed(
              (index, view) => SubCategoryWidget(
                view: view,
                hasDivider: index < selectionViews.length - 1,
                categoryId: categoryId,
                search: search,
              ),
            )
            .toList(),
      );
}

class CategoriesCard extends StatelessWidget {
  const CategoriesCard({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsetsDirectional.only(
          top: Spacing.$4x,
          bottom: Spacing.$4x,
        ),
        margin: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(RadiusBorder.xl),
          ),
          color: context.colors.backgroundSurface1,
        ),
        child: child,
      );
}

class SubCategoryWidget extends StatelessWidget {
  const SubCategoryWidget({
    required this.view,
    required this.hasDivider,
    this.categoryId,
    this.search,
    super.key,
  });

  final SelectionView<String> view;
  final bool hasDivider;
  final String? categoryId;
  final String? search;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: view,
        builder: (context, _) => Container(
          margin: const EdgeInsetsDirectional.only(end: Spacing.$4x),
          height: AppSizes.l,
          child: ContentRow(
            key: ValueKey<bool>(view.isHighlighted),
            leading: categoryId != null ? getCategorySvg(categoryId!) : null,
            onTap: () => view.onTap(context),
            text: ContentRowTextOptions(
              titleOptions: ContentRowTextOption(
                builder: (context) {
                  final color = context.colors.foregroundDefault;
                  final baseStyle = context.textStyles.captionLargeRegular
                      .copyWith(color: color);

                  return search != null
                      ? Text.rich(
                          TextSpan(
                            children: getHighlightedTextSpans(
                              source: view.title,
                              search: search!,
                              highlightStyle: context
                                  .textStyles.captionLargeSemiBold
                                  .copyWith(color: color),
                              baseStyle: baseStyle,
                            ),
                          ),
                        )
                      : Text(
                          view.title,
                          style: baseStyle,
                        );
                },
              ),
            ),
            isDividerEnabled: hasDivider,
            supportTitleRTL: true,
            trailing: ContentRowCustomTrailingOptions(
              builder: (context) => BaladyCheckBox(
                state: view.isHighlighted
                    ? BaladyCheckBoxState.checked
                    : BaladyCheckBoxState.unchecked,
                disable: false,
                onChanged: (_) => view.onTap(context),
              ),
            ),
          ),
        ),
      );
}
