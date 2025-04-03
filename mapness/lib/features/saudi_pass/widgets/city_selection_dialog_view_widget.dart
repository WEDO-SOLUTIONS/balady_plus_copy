import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mapness/features/saudi_pass/views/city_selection_dialog_view.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/hooks/stateless_botomsheet_controller_hook.dart';
import 'package:mapness/shared/ui/buttons/app_close_button.dart';

class CitySelectionDialogViewWidget extends HookWidget {
  final CitySelectionDialogView citySelectionDialogView;

  const CitySelectionDialogViewWidget(this.citySelectionDialogView, {super.key});

  @override
  Widget build(BuildContext context) {
    final scrollController = useStatelessBottomsheetController(
      onClose: (_) => citySelectionDialogView.onCrossTap(),
      heightModel: BottomSheetAspectRatioHeightModel(1.0),
    );

    final textEditingController = useTextEditingController();

    useEffect(() {
      void inputListener() => citySelectionDialogView.onSearchInput(textEditingController.text);
      textEditingController.addListener(inputListener);
      return textEditingController.dispose;
    }, [textEditingController]);

    const horizontalPadding = EdgeInsets.symmetric(horizontal: Spacing.$4x);

    Color backgroundColorDelegate(StatelessBottomSheetController controller) => context.colorsV3.screenOverlayDimming40
        .withOpacity(Curves.easeIn.transform(controller.aspectRatio.clamp(0, 1)) * 0.7);

    return SafeArea(
      child: StatelessBottomSheet(
        backgroundColorDelegate: backgroundColorDelegate,
        startConfig: BottomSheetStart.instant,
        scrollController: scrollController,
        header: Padding(
          padding: horizontalPadding.copyWith(bottom: Spacing.$4x),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(context.l10n.saudiPassCitySelectionPageTitle, style: context.textStyleV3.h2SemiBold),
              CustomCloseButton(onClose: citySelectionDialogView.onCrossTap),
            ],
          ),
        ),
        sliverBeforeContent: SliverFillRemaining(
          child: Column(
            children: [
              Padding(
                padding: horizontalPadding,
                child: BaladySearchWithBackButton(
                  searchInput: BaladyInput.searchV2(
                    autofocus: true,
                    controller: textEditingController,
                    hintText: context.l10n.saudiPassCitySelectionPageSearchHint,
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
        child: ContentRowV2(
          onTap: view.onTap,
          leading: Icon(
            SystemIcons.search,
            color: view.isMagnifierVisible ? context.colorsV2.foregroundMuted : Colors.transparent,
          ),
          text: ContentRowTextOptions(
            titleOptions: ContentRowTextOption(
              builder: (context) {
                final color = context.colorsV2.foregroundDefault;
                return Text.rich(
                  TextSpan(
                    children: highlightedTextSpans(
                      source: view.title,
                      search: citySelectionDialogView.search,
                      highlightStyle: context.textStyleV3.bodyLargeSemiBold.copyWith(color: color),
                      baseStyle: context.textStyleV3.bodySmallRegular.copyWith(color: color),
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

List<TextSpan> highlightedTextSpans({
  required String source,
  required String search,
  required TextStyle highlightStyle,
  required TextStyle baseStyle,
}) {
  if (search.isEmpty || !source.toLowerCase().contains(search.toLowerCase())) {
    return [TextSpan(text: source, style: baseStyle)];
  }

  final matches = search.toLowerCase().allMatches(source.toLowerCase());

  int lastMatchEnd = 0;

  final List<TextSpan> children = [];
  for (var i = 0; i < matches.length; i++) {
    final match = matches.elementAt(i);

    if (match.start != lastMatchEnd) {
      children.add(TextSpan(text: source.substring(lastMatchEnd, match.start), style: baseStyle));
    }

    children.add(TextSpan(text: source.substring(match.start, match.end), style: highlightStyle));

    if (i == matches.length - 1 && match.end != source.length) {
      children.add(TextSpan(text: source.substring(match.end, source.length), style: baseStyle));
    }

    lastMatchEnd = match.end;
  }
  return children;
}
