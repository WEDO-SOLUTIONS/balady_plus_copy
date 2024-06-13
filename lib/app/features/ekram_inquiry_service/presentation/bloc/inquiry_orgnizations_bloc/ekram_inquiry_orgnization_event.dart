import 'package:balady_plus/app/features/new_appointment/presentation/core/models/lookup_list_model.dart';
import 'package:equatable/equatable.dart';

abstract class EkramOrgnizationCemetryEvent extends Equatable {
  const EkramOrgnizationCemetryEvent();

  @override
  List<Object> get props => [];
}

class FindCemetriesEvent extends EkramOrgnizationCemetryEvent {
  const FindCemetriesEvent();
}

class GetEkramCitiesEvent extends EkramOrgnizationCemetryEvent {
  const GetEkramCitiesEvent();
}

class SelectCityEvent extends EkramOrgnizationCemetryEvent {
  final LookUpItem item;
  const SelectCityEvent({required this.item});
}

class ClearEvent extends EkramOrgnizationCemetryEvent {
  const ClearEvent();
}
