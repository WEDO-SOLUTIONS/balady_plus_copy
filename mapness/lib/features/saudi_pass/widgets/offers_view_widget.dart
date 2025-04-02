import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/widgets.dart';
import 'package:mapness/features/saudi_pass/views/offers_view.dart';
import 'package:mapness/features/saudi_pass/widgets/offers_filters_view_widget.dart';
import 'package:mapness/features/saudi_pass/widgets/offers_list_widget.dart';
import 'package:mapness/features/saudi_pass/widgets/set_preferences_placeholder_widget.dart';

class OffersViewWidget extends StatelessWidget {
  final OffersView offersView;

  const OffersViewWidget(this.offersView, {super.key});

  @override
  Widget build(BuildContext context) => FutureBuilder(
        key: ObjectKey(offersView.offersFiltersFuture),
        future: offersView.offersFiltersFuture,
        builder: (_, allOffersViewSnapshot) {
          if (allOffersViewSnapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.all(Spacing.$4x).copyWith(top: Spacing.$3x),
              child: WentWrongPlaceholderWidget(action: offersView.tapRetryAll),
            );
          }

          final offersFiltersView = allOffersViewSnapshot.data;

          if (offersFiltersView != null) {
            final filters = OffersFiltersViewWidget(offersFiltersView);

            final list = ListenableBuilder(
              listenable: offersFiltersView,
              builder: (context, _) => OffersListWidget(offersFiltersView.asyncIterableOffers),
            );

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: Spacing.$3x),
                  child: SizedBox(height: AppSizes.l, child: filters),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
                    child: list,
                  ),
                ),
              ],
            );
          }

          return const Center(child: Loading(size: LoaderSize.large));
        },
      );
}
