import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapness/features/poi_reviews/ui/poi_rated_toast.dart';
import 'package:mapness/features/poi_reviews/ui/widgets/poi_rate_card.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';
import 'package:provider/provider.dart';

// PoiReviewsSliver itself can't be pumped here: its route import pulls in the whole app, which doesn't
// compile against the local balady_authorization stub. This covers what its star tap handler runs before
// the push: the Rate card callback and PoiRatedToast.of.
void main() {
  testWidgets('star tap in the Rate card builds the rated toast without a listening theme lookup', (tester) async {
    int? tappedRating;
    PoiRatedToast? toast;
    final themeController = ThemeController();

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: themeController,
        child: MaterialApp(
          theme: ThemeData(extensions: [ThemeTextStylesV3.golos()]),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Builder(
                builder: (context) => PoiRateCard(
                  onRate: (rating) {
                    tappedRating = rating;
                    toast = PoiRatedToast.of(context);
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('rating_star-3-false')));
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(tappedRating, 4);
    expect(toast?.title, 'Rated this place');
    expect(toast?.starColor, themeController.colors.warningDefault);
  });
}
