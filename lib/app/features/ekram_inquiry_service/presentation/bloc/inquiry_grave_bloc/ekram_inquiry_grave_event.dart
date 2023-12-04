import 'package:balady_plus/app/features/new_appointment/presentation/core/models/lookup_list_model.dart';
import 'package:equatable/equatable.dart';

abstract class EkramInquiryGraveEvent extends Equatable {
  const EkramInquiryGraveEvent();

  @override
  List<Object> get props => [];
}

class FindCemetriesEvent extends EkramInquiryGraveEvent {
  const FindCemetriesEvent();
}

class GetEkramCitiesEvent extends EkramInquiryGraveEvent {
  const GetEkramCitiesEvent();
}

class SelectCityEvent extends EkramInquiryGraveEvent {
  final LookUpItem item;
  const SelectCityEvent({required this.item});
}

class SelectNationalityEvent extends EkramInquiryGraveEvent {
  final LookUpItem item;
  const SelectNationalityEvent({required this.item});
}

class SelectNationalIdTypeEvent extends EkramInquiryGraveEvent {
  final LookUpItem item;
  const SelectNationalIdTypeEvent({required this.item});
}

class ChangeFullNameEvent extends EkramInquiryGraveEvent {
  final String? value;
  const ChangeFullNameEvent({required this.value});
}

class ChangeIdentityNoEvent extends EkramInquiryGraveEvent {
  final String? value;
  const ChangeIdentityNoEvent({required this.value});
}
