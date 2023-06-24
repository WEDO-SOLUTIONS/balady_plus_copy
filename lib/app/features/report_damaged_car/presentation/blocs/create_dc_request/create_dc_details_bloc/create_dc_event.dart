part of 'create_dc_bloc.dart';

abstract class CreateDCEvent extends Equatable {
  const CreateDCEvent();

  @override
  List<Object> get props => [];
}

class GoToNextPageEvent extends CreateDCEvent {
  GoToNextPageEvent();
}

class GoToPreviousPageEvent extends CreateDCEvent {
  GoToPreviousPageEvent();
}

class EditCreateVDPageEvent extends CreateDCEvent {
  final CreateVDParamsPage params;

  EditCreateVDPageEvent({required this.params});
}

class ChangeAddressEvent extends CreateDCEvent {
  ChangeAddressEvent();
}

class ChangeIssueDescEvent extends CreateDCEvent {
  final String? text;
  ChangeIssueDescEvent({this.text});
}

class UploadFileEvent extends CreateDCEvent {
  final UploadFileParams params;
  UploadFileEvent({required this.params});
}

class SubmitIncidentEvent extends CreateDCEvent {
  final String? otpValue;
  final CreateIncidentParams? params;

  SubmitIncidentEvent({this.otpValue, this.params});
}

class CreateIncidentRegisteredEvent extends CreateDCEvent {
  final CreateIncidentParams? params;
  CreateIncidentRegisteredEvent({this.params});
}

class ChangeAgreementEvent extends CreateDCEvent {
  final bool? isagree;
  ChangeAgreementEvent({this.isagree});
}

class GetCarTypesEvent extends CreateDCEvent {
  GetCarTypesEvent();
}

class GetCarModelsEvent extends CreateDCEvent {
  final DropDownItem? item;
  GetCarModelsEvent({required this.item});
}

class SelectCarModelEvent extends CreateDCEvent {
  final DropDownItem? item;
  SelectCarModelEvent({this.item});
}

class SelectReportTypeEvent extends CreateDCEvent {
  final DropDownItem? item;
  SelectReportTypeEvent({this.item});
}

class SelectRegisterTypeEvent extends CreateDCEvent {
  final DropDownItem? item;
  SelectRegisterTypeEvent({this.item});
}

class ChangeCarDetailsEvent extends CreateDCEvent {
  final String? chassisNumber;
  final String? plateDigit;
  final String? leftLetter;
  final String? middleLetter;
  final String? rightLetter;

  ChangeCarDetailsEvent(
      {this.chassisNumber,
      this.plateDigit,
      this.leftLetter,
      this.middleLetter,
      this.rightLetter});
}
