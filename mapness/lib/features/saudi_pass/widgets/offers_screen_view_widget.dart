import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/saudi_pass/views/offers_screen_view.dart';
import 'package:mapness/features/saudi_pass/widgets/offers_view_widget.dart';
import 'package:mapness/features/saudi_pass/widgets/prefs_content_widget.dart';
import 'package:mapness/features/saudi_pass/widgets/saudi_pass_scaffold.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class OffersScreenViewWidget extends ConsumerStatefulWidget {
  final OffersScreenView offersScreenView;

  const OffersScreenViewWidget(this.offersScreenView, {super.key});

  @override
  OffersScreenViewWidgetState createState() => OffersScreenViewWidgetState();
}

class OffersScreenViewWidgetState extends ConsumerState<OffersScreenViewWidget> {
  int get _filtersIndex => widget.offersScreenView.isByPreferencesElseAll ? 0 : 1;
  bool _hasChangeFavorites = false;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: Spacing.$4x),
        child: FutureBuilder<OffersFiltersView>(
            future: widget.offersScreenView.offersFiltersFuture,
            builder: (_, s) => SaudiPassScaffold(
                  onShowOnMapPressed: s.hasData
                      ? () => context.router.push(
                            OffersOnMapRoute(
                              categories: s.data!.categories,
                              recommendedTypes: s.data!.recommendedTypes,
                            ),
                          )
                      : null,
                  onBackButton: () => context.router.popForced(_hasChangeFavorites),
                  title: context.l10n.saudiPassOffersPageTitle,
                  body: ListenableBuilder(
                    listenable: widget.offersScreenView,
                    builder: (context, _) => Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(Spacing.$4x).copyWith(bottom: 0),
                          child: SegmentTabsButton(
                            initialIndex: _filtersIndex,
                            tabsContent: [
                              TabsRowV2Content(
                                title: context.l10n.saudiPassOffersPageByPreferences,
                                onTap: widget.offersScreenView.tapByPreferences,
                              ),
                              TabsRowV2Content(
                                title: context.l10n.saudiPassOffersPageAll,
                                onTap: widget.offersScreenView.tapAll,
                              ),
                            ],
                            onIndexChanged: (index) {},
                          ),
                        ),
                        Expanded(
                          child: IndexedStack(
                            index: _filtersIndex,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
                                child: PrefsContentWidget(widget.offersScreenView),
                              ),
                              OffersViewWidget(
                                widget.offersScreenView,
                                onChangeOffers: () => _hasChangeFavorites = true,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
      );
}
