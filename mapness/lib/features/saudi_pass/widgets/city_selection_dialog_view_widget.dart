import 'package:auto_route/auto_route.dart';
import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mapness/features/saudi_pass/functions/get_highlighted_text_spans.dart';
import 'package:mapness/features/saudi_pass/views/city_selection_dialog_view.dart';
import 'package:mapness/features/saudi_pass/views/search_view.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/hooks/toggle_sheet_controller_hook.dart';
import 'package:mapness/shared/ui/buttons/app_close_button.dart';
import 'package:sheetify/sheetify.dart';

class CitySelectionDialogViewWidget extends HookWidget {
  final CitySelectionDialogView citySelectionDialogView;

  const CitySelectionDialogViewWidget(this.citySelectionDialogView, {super.key});

  @override
  Widget build(BuildContext context) {
    final scrollController = useToggleSheetController(
      onClose: (_) => context.router.pop(),
      heightModel: ToggleSheetHeightModel.fraction(0.99),
    );

    final textEditingController = useTextEditingController();

    useListenable(textEditingController);

    useEffect(() {
      citySelectionDialogView.onSearchInput(textEditingController.text);
      return null;
    }, [textEditingController.text]);
    const horizontalPadding = EdgeInsets.symmetric(horizontal: Spacing.$4x);

    return SafeArea(
      bottom: false,
      child: ToggleSheet(
        barrierColorDelegate: ToggleSheetDelegateFunction<Color?>(
          function: (controller) => AppColor.black.withOpacity(0.4 * (1 - controller.interpolation)),
        ),
        backgroundColor: context.colors.backgroundSurface2,
        safeAreaColor: context.colors.backgroundSurface2,
        scrollController: scrollController,
        header: Padding(
          padding: horizontalPadding.copyWith(bottom: Spacing.$4x),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.l10n.saudiPassCitySelectionPageTitle,
                style: context.textStyles.h2SemiBold.copyWith(color: context.colors.foregroundDefault),
              ),
              CustomCloseButton(onClose: context.router.pop),
            ],
          ),
        ),
        sliver: SliverFillRemaining(
          child: Column(
            children: [
              Padding(
                padding: horizontalPadding,
                child: BaladySearchWithBackButtonV2(
                  searchInput: BaladyTextInput(
                    config: BaladyInputConfig(
                      autofocus: true,
                      hintText: context.l10n.saudiPassCitySelectionPageSearchHint,
                      isDisposed: false,
                    ),
                    controller: textEditingController,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(start: Spacing.$2x, end: Spacing.$4x),
                  child: ListenableBuilder(
                    listenable: citySelectionDialogView,
                    builder: (context, _) {
                      final searchViews = citySelectionDialogView.searchViews;

                      return ListView.builder(
                        itemBuilder: (_, index) => SearchViewWidget(
                          view: searchViews.elementAt(index),
                          citySelectionDialogView: citySelectionDialogView,
                          isDividerEnabled: index < searchViews.length - 1,
                        ),
                        itemCount: searchViews.length,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchViewWidget extends StatelessWidget {
  final CitySelectionDialogView citySelectionDialogView;
  final SearchView view;
  final bool isDividerEnabled;

  const SearchViewWidget({
    required this.view,
    required this.citySelectionDialogView,
    required this.isDividerEnabled,
    super.key,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
    height: AppSizes.l,
    child: ContentRow(
      onTap: () => view.onTap(context),
      leading: Icon(
        SystemIcons.search,
        color: view.isMagnifierVisible ? context.colors.foregroundMuted : Colors.transparent,
      ),
      text: ContentRowTextOptions(
        titleOptions: ContentRowTextOption(
          builder: (context) {
            final color = context.colors.foregroundDefault;
            return Text.rich(
              TextSpan(
                children: getHighlightedTextSpans(
                  source: view.title,
                  search: citySelectionDialogView.search,
                  highlightStyle: context.textStyles.bodyLargeSemiBold.copyWith(color: color),
                  baseStyle: context.textStyles.bodySmallRegular.copyWith(color: color),
                ),
              ),
            );
          },
        ),
      ),
      isDividerEnabled: isDividerEnabled,
      supportTitleRTL: true,
    ),
  );
}
