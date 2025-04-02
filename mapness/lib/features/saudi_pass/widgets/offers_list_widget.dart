import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/widgets.dart';
import 'package:mapness/features/saudi_pass/async_iterable/async_iterable.dart';
import 'package:mapness/features/saudi_pass/async_iterable/async_iterable_listing_notifier.dart';
import 'package:mapness/features/saudi_pass/views/offers_screen_view.dart';
import 'package:mapness/features/saudi_pass/widgets/offer_view_widget.dart';

class OffersListWidget extends StatefulWidget {
  final AsyncIterable<OfferView> asyncIterableOffers;

  const OffersListWidget(this.asyncIterableOffers, {super.key});

  @override
  State<OffersListWidget> createState() => _OffersListWidgetState();
}

class _OffersListWidgetState extends State<OffersListWidget> {
  AsyncIterableListingNotifier<OfferView> decorateNew(AsyncIterable<OfferView> decorated) =>
      AsyncIterableListingNotifier(decorated);

  late AsyncIterableListingNotifier<OfferView> offers = decorateNew(widget.asyncIterableOffers);

  @override
  void didUpdateWidget(OffersListWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (offers.decorated != widget.asyncIterableOffers) {
      offers = decorateNew(widget.asyncIterableOffers);
    }
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: offers,
        builder: (context, _) {
          if (offers.isEmpty) {
            return const SizedBox.shrink();
          }

          return ListView.separated(
            key: ObjectKey(widget.asyncIterableOffers),
            itemCount: offers.length,
            separatorBuilder: (context, _) => const SizedBox(height: Spacing.$3x),
            itemBuilder: (_, index) => SizedBox(
              height: 78,
              child: FutureBuilder(
                future: offers.hasElement(index),
                builder: (_, s) {
                  if (s.hasData) {
                    if (s.requireData) {
                      return OfferViewWidget(offers.elementAt(index));
                    } else {
                      return Text('index:$index has no Element');
                    }
                  }

                  return const Center(child: Loading(size: LoaderSize.large));
                },
              ),
            ),
          );
        },
      );
}
