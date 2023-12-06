import 'package:balady_plus/app/features/new_appointment/presentation/core/models/lookup_list_model.dart';
import 'package:equatable/equatable.dart';

abstract class EkramInquiryCemetryEvent extends Equatable {
  const EkramInquiryCemetryEvent();

  @override
  List<Object> get props => [];
}

class FindCemetriesEvent extends EkramInquiryCemetryEvent {
  const FindCemetriesEvent();
}

class GetEkramCitiesEvent extends EkramInquiryCemetryEvent {
  const GetEkramCitiesEvent();
}

class GetEkramDistrictsEvent extends EkramInquiryCemetryEvent {
  final LookUpItem city;
  const GetEkramDistrictsEvent({required this.city});
}

class SelectDistrcitEvent extends EkramInquiryCemetryEvent {
  final LookUpItem item;
  const SelectDistrcitEvent({required this.item});
}

class ChangeIsMuslimEvent extends EkramInquiryCemetryEvent {
  final bool value;
  const ChangeIsMuslimEvent({required this.value});
}

class ChangeLaundryExistEvent extends EkramInquiryCemetryEvent {
  final bool value;
  const ChangeLaundryExistEvent({required this.value});
}

class ClearEvent extends EkramInquiryCemetryEvent {
  const ClearEvent();
}
