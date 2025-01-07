part of 'create_vd_bloc.dart';

abstract class CreateVDEvent extends Equatable {
  const CreateVDEvent();

  @override
  List<Object> get props => [];
}

class GoToNextPageEvent extends CreateVDEvent {
  GoToNextPageEvent();
}

class GoToPreviousPageEvent extends CreateVDEvent {
  GoToPreviousPageEvent();
}

class ShowSPLSearchEvent extends CreateVDEvent {
  ShowSPLSearchEvent();
}

class SearchForSPLEvent extends CreateVDEvent {
  final String? text;
  SearchForSPLEvent({this.text});
}

class EditCreateVDPageEvent extends CreateVDEvent {
  final CreateVDParamsPage params;

  EditCreateVDPageEvent({required this.params});
}

class ChangeAddressEvent extends CreateVDEvent {
  ChangeAddressEvent();
}

class ChangeIssueDescEvent extends CreateVDEvent {
  final String? text;
  ChangeIssueDescEvent({this.text});
}

class GetSPLDetailsEvent extends CreateVDEvent {
  final SPLDetailsParams params;
  final int selectedIndex;
  final bool? autoSelect;
  GetSPLDetailsEvent(
      {required this.params,
      required this.selectedIndex,
      this.autoSelect = false});
}

class UploadFileEvent extends CreateVDEvent {
  final UploadFileParams params;
  UploadFileEvent({required this.params});
}

class GetOTPEvent extends CreateVDEvent {
  final OTPParams params;
  GetOTPEvent({required this.params});
}

class SubmitIncidentEvent extends CreateVDEvent {
  final String? otpValue;
  final CreateIncidentParams? params;

  SubmitIncidentEvent({this.otpValue, this.params});
}

class CreateIncidentRegisteredEvent extends CreateVDEvent {
  final CreateIncidentParams? params;
  CreateIncidentRegisteredEvent({this.params});
}

class CreateIncidentUnRegisteredEvent extends CreateVDEvent {
  final String otpValue;
  final CreateIncidentParams? params;

  CreateIncidentUnRegisteredEvent({required this.otpValue, this.params});
}

class ChangeGuestMobileEvent extends CreateVDEvent {
  final String? text;
  ChangeGuestMobileEvent({this.text});
}

class ChangeGuestFirstNameEvent extends CreateVDEvent {
  final String? text;
  ChangeGuestFirstNameEvent({this.text});
}

class ChangeGuestLastNameEvent extends CreateVDEvent {
  final String? text;
  ChangeGuestLastNameEvent({this.text});
}

class ChangeAgreementEvent extends CreateVDEvent {
  final bool? isagree;
  ChangeAgreementEvent({this.isagree});
}

// Addetional Fields
class ChangeSelectedTextValueEvent extends CreateVDEvent {
  final String? text;
  final int index;
  ChangeSelectedTextValueEvent({required this.index, this.text});
}

class ChangeSelectedDropDownValueEvent extends CreateVDEvent {
  final ValueItem? item;
  final int index;
  ChangeSelectedDropDownValueEvent({required this.index, this.item});
}

class ChangeSelectedMultiSelectValueEvent extends CreateVDEvent {
  final List<ValueItem>? items;
  final int index;
  ChangeSelectedMultiSelectValueEvent({required this.index, this.items});
}

class GetSplListEvent extends CreateVDEvent {
  final SplParams params;
  final int nextPage;
  GetSplListEvent({required this.params, required this.nextPage});
}

class ChangeCrNumberEvent extends CreateVDEvent {
  final String crNumber;
  ChangeCrNumberEvent({required this.crNumber});
}

class VerifyCrNumberEvent extends CreateVDEvent {
  VerifyCrNumberEvent();
}
