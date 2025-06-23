import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/widgets.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/saudi_pass/views/favourite_offers_screen_view.dart';
import 'package:mapness/features/saudi_pass/widgets/offers_view_widget.dart';
import 'package:mapness/features/saudi_pass/widgets/saudi_pass_scaffold.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class FavouriteOffersScreenViewWidget extends StatelessWidget {
  final FavouriteOffersScreenView favouriteOffersScreenView;

  const FavouriteOffersScreenViewWidget(this.favouriteOffersScreenView, {super.key});

  @override
  Widget build(BuildContext context) => SaudiPassScaffold(
        onBackButton: context.router.popForced,
        title: context.l10n.saudiPassFavoritesOffersPageTitle,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: OffersViewWidget(favouriteOffersScreenView)),
              Padding(
                padding: const EdgeInsets.all(Spacing.$4x).copyWith(top: Spacing.$3x),
                child: BaladyAppButton(
                  primaryLabel: context.l10n.saudiPassFavoritesOffersPageGoToAllOffers,
                  buttonColorScheme: BaladyButtonColorScheme.accentSecondary,
                  buttonType: BaladyButtonType.secondary,
                  onTap: () => context.router.push(OffersScreenViewRoute()),
                ),
              ),
            ],
          ),
        ),
      );
}
