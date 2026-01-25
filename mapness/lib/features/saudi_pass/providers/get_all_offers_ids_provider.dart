import 'package:mapness/features/saudi_pass/providers/offer_details_provider.dart';
import 'package:mapness/features/saudi_pass/repo/offer_details_body.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_all_offers_ids_provider.g.dart';

@riverpod
class GetAllOffersIds extends _$GetAllOffersIds {
  @override
  Future<List<OfferDetails>> build(List<String> ids) async {
    state = const AsyncLoading();
    final offers = (await Future.wait(
      ids.map((id) async {
        try {
          return await ref.watch(offerDetailsProvider(id).future);
        } catch (e, _) {
          return null;
        }
      }),
    ))
        .nonNulls
        .toList();
    state = AsyncData(offers);
    return offers;
  }
}
