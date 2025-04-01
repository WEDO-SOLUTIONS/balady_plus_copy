import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/saudi_pass/views/offers_screen.dart';
import 'package:mapness/features/saudi_pass/widgets/offers_view_widget.dart';
import 'package:mapness/features/saudi_pass/widgets/prefs_content_widget.dart';
import 'package:mapness/features/saudi_pass/widgets/saudi_pass_scaffold.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class OffersScreenWidget extends ConsumerWidget {
  const OffersScreenWidget(this.offersScreen, {super.key});

  final OffersScreen offersScreen;

  int get filtersIndex => offersScreen.isByPreferencesElseAll ? 0 : 1;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final segmentedTabsPrefsAndAll = SegmentTabsButton(
      initialIndex: filtersIndex,
      tabsContent: [
        TabsRowV2Content(
          title: context.l10n.saudiPassOffersPageByPreferences,
          onTap: offersScreen.tapByPreferences,
        ),
        TabsRowV2Content(
          title: context.l10n.saudiPassOffersPageAll,
          onTap: offersScreen.tapAll,
        ),
      ],
      onIndexChanged: (index) {},
    );

    return Padding(
      padding: const EdgeInsets.only(top: Spacing.$4x),
      child: SaudiPassScaffold(
        onBackButton: offersScreen.tapBack,
        title: context.l10n.saudiPassOffersPageTitle,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(Spacing.$4x).copyWith(bottom: 0),
              child: segmentedTabsPrefsAndAll,
            ),
            Expanded(
              child: ListenableBuilder(
                listenable: offersScreen,
                builder: (context, _) => IndexedStack(
                  index: filtersIndex,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
                      child: PrefsContentWidget(offersScreen),
                    ),
                    OffersViewWidget(offersScreen),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
