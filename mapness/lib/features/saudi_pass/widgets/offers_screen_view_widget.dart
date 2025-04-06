import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/saudi_pass/views/offers_screen_view.dart';
import 'package:mapness/features/saudi_pass/widgets/offers_view_widget.dart';
import 'package:mapness/features/saudi_pass/widgets/prefs_content_widget.dart';
import 'package:mapness/features/saudi_pass/widgets/saudi_pass_scaffold.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class OffersScreenViewWidget extends ConsumerWidget {
  const OffersScreenViewWidget(this.offersScreenView, {super.key});

  final OffersScreenView offersScreenView;

  int get filtersIndex => offersScreenView.isByPreferencesElseAll ? 0 : 1;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Padding(
        padding: const EdgeInsets.only(top: Spacing.$4x),
        child: SaudiPassScaffold(
          onBackButton: offersScreenView.tapBack,
          title: context.l10n.saudiPassOffersPageTitle,
          body: ListenableBuilder(
            listenable: offersScreenView,
            builder: (context, _) => Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(Spacing.$4x).copyWith(bottom: 0),
                  child: SegmentTabsButton(
                    initialIndex: filtersIndex,
                    tabsContent: [
                      TabsRowV2Content(
                        title: context.l10n.saudiPassOffersPageByPreferences,
                        onTap: offersScreenView.tapByPreferences,
                      ),
                      TabsRowV2Content(
                        title: context.l10n.saudiPassOffersPageAll,
                        onTap: offersScreenView.tapAll,
                      ),
                    ],
                    onIndexChanged: (index) {},
                  ),
                ),
                Expanded(
                  child: IndexedStack(
                    index: filtersIndex,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
                        child: PrefsContentWidget(offersScreenView),
                      ),
                      OffersViewWidget(offersScreenView),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
