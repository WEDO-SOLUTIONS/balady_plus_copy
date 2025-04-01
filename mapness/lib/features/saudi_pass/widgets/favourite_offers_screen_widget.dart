import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/widgets.dart';
import 'package:mapness/features/saudi_pass/views/favourite_offers_screen.dart';
import 'package:mapness/features/saudi_pass/widgets/offers_view_widget.dart';
import 'package:mapness/features/saudi_pass/widgets/saudi_pass_scaffold.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class FavouriteOffersScreenWidget extends StatelessWidget {
  final FavouriteOffersScreen favouriteOffersScreen;

  const FavouriteOffersScreenWidget(this.favouriteOffersScreen, {super.key});

  @override
  Widget build(BuildContext context) => SaudiPassScaffold(
        onBackButton: favouriteOffersScreen.tapBack,
        title: context.l10n.saudiPassFavoritesOffersPageTitle,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: OffersViewWidget(favouriteOffersScreen)),
            Padding(
              padding: const EdgeInsets.all(Spacing.$4x).copyWith(top: Spacing.$3x),
              child: BaladyAppButton(
                primaryLabel: context.l10n.saudiPassFavoritesOffersPageGoToAllOffers,
                buttonColorScheme: BaladyButtonColorScheme.accentSecondary,
                buttonType: BaladyButtonType.secondary,
                onTap: favouriteOffersScreen.tapGotoAllOffers,
              ),
            ),
          ],
        ),
      );
}
