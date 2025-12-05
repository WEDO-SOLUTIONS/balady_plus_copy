import 'dart:async';

import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:mapness/entities/saudi_pass/offers_group.dart';
import 'package:mapness/features/saudi_pass/notifiers/offers_screen_view_notifier.dart';
import 'package:mapness/features/saudi_pass/providers/saudi_pass_city_by_location_riverpod.dart';
import 'package:mapness/features/saudi_pass/providers/saudi_pass_repository_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'offers_screen_view_riverpod.g.dart';

@riverpod
class OffersScreenViewRiverpod extends _$OffersScreenViewRiverpod {
  @override
  OffersScreenViewNotifier build({OffersGroup? offersGroup}) {
    final notifier = OffersScreenViewNotifier(
      saudiPassRepository: ref.read(saudiPassRepositoryProvider.future),
      ref: ref,
      cityIdByLocation: ref.read(saudiPassCityIdByLocationProvider.future),
      offersGroup: offersGroup,
    );

    // Show offers by preferences if user is logged in
    if (CommonProperties.isLoggedIn) {
      unawaited(
        notifier.prefsOffersViewFuture.then(
          (value) {
            if (value.preferences.isNotPopulated) {
              notifier.isByPreferencesElseAll = false;
            }
          },
        ),
      );
      notifier.isByPreferencesElseAll = true;
    }

    ref.onDispose(notifier.dispose);

    return notifier;
  }
}
