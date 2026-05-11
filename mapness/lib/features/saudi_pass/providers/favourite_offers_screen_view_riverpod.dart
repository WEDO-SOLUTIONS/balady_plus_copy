import 'package:mapness/features/saudi_pass/notifiers/favourite_offers_screen_view_notifier.dart';
import 'package:mapness/features/saudi_pass/providers/saudi_pass_repository_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'favourite_offers_screen_view_riverpod.g.dart';

@riverpod
class FavouriteOffersScreenViewRiverpod extends _$FavouriteOffersScreenViewRiverpod {
  @override
  FavouriteOffersScreenViewNotifier build() {
    final futureRepo = ref.read(saudiPassRepositoryProvider.future);

    final notifier = FavouriteOffersScreenViewNotifier(
      saudiPassRepository: futureRepo,
      ref: ref,
    );

    ref.onDispose(notifier.dispose);

    return notifier;
  }
}
