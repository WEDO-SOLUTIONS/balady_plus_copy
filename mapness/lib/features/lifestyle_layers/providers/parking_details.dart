import 'dart:async';

import 'package:balady_uikit/balady_uikit.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/widgets.dart';
import 'package:mapness/_features/common/providers/shared_prefs.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/parking_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'parking_details.g.dart';

extension ParkingFilterExt on ParkingFilter {
  String title(AppLocalizations l10n) => switch (this) {
    ParkingFilter.all => l10n.parkingLotFilterAll,
    ParkingFilter.free => l10n.parkingLotFilterFree,
    ParkingFilter.paid => l10n.parkingLotFilterPaid,
    _ => '',
  };

  IconData icon() => switch (this) {
    ParkingFilter.all => TransportIcons.parkingEnable,
    ParkingFilter.free => GeneralIcons.checkmarkCircle,
    ParkingFilter.paid => GeneralIcons.timeQuarter,
    _ => GeneralIcons.placeholder,
  };

  bool paidOn() => switch (this) {
    ParkingFilter.all => true,
    ParkingFilter.paid => true,
    _ => false,
  };

  bool freeOn() => switch (this) {
    ParkingFilter.all => true,
    ParkingFilter.free => true,
    _ => false,
  };
}

class ParkingState {
  final ParkingFilter parkingFilter;

  ParkingState({
    required this.parkingFilter,
  });

  ParkingState copyWith(ParkingFilter parkingFilter) => ParkingState(parkingFilter: parkingFilter);
}

@riverpod
class ParkingDetails extends _$ParkingDetails {
  @override
  ParkingState build() {
    final prefs = ref.read(sharedPrefsProvider);
    final attribute = prefs.getString(parkingTypeKey);
    final parkingFilter = attribute != null ? ParkingFilter.fromAttribute(attribute) : ParkingFilter.all;

    return ParkingState(parkingFilter: parkingFilter);
  }

  void update(ParkingFilter parkingFilter) {
    state = state.copyWith(parkingFilter);
  }

  Future<void> setParkingFilter(ParkingFilter parkingFilter) async {
    final prefs = ref.read(sharedPrefsProvider);
    await prefs.setString(parkingTypeKey, parkingFilter.name);

    update(parkingFilter);
    await _applyAttribute(parkingFilter);
  }

  Future<void> _applyAttribute(ParkingFilter parkingFilter) async {
    final _dgisController = await ref.read(dgisControllerProvider.future);
    await _dgisController.setMapAttributeBool(attributeParkingOn, value: true);
    await _dgisController.setMapAttributeBool(attributeParkingFilteredPaidOn, value: parkingFilter.paidOn());
    await _dgisController.setMapAttributeBool(attributeParkingFilteredFreeOn, value: parkingFilter.freeOn());
  }
}
