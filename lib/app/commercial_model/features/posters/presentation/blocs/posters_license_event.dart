part of 'posters_license_bloc.dart';

@immutable
abstract class PostersLicenseEvent extends Equatable {
  const PostersLicenseEvent();

  @override
  List<Object> get props => [];
}

class GoToNextPageEvent extends PostersLicenseEvent {
  const GoToNextPageEvent();
}

class GoToPreviousPageEvent extends PostersLicenseEvent {
  const GoToPreviousPageEvent();
}

class GetLicensePermitsEvents extends PostersLicenseEvent {
  const GetLicensePermitsEvents();
}

class ChangePermitStartDate extends PostersLicenseEvent {
  final String? date;
  const ChangePermitStartDate({this.date});
}

class ChangePermitDurationEvent extends PostersLicenseEvent {
  final String? value;
  const ChangePermitDurationEvent({this.value});
}

class GetPosterTypesEvent extends PostersLicenseEvent {
  const GetPosterTypesEvent();
}

class AddPosterItemEvent extends PostersLicenseEvent {
  final PosterItem item;
  final int? index;
  const AddPosterItemEvent({required this.item, this.index});
}

class UpdatePermitsLicenses extends PostersLicenseEvent {
  final List<PermitsLicensesItem> selectedValues;
  const UpdatePermitsLicenses({required this.selectedValues});
}

class ApplyPosterGroupEvent extends PostersLicenseEvent {
  const ApplyPosterGroupEvent();
}

class SavePostersInfo extends PostersLicenseEvent {
  const SavePostersInfo();
}

class SubmitPosterEvent extends PostersLicenseEvent {
  final bool editMode;
  const SubmitPosterEvent({this.editMode = false});
}

class AddIndividualRequestsEvent extends PostersLicenseEvent {
  const AddIndividualRequestsEvent();
}

class GetPosterRequestDetailsEvent extends PostersLicenseEvent {
  const GetPosterRequestDetailsEvent();
}

class GetPostersGroupsEvent extends PostersLicenseEvent {
  const GetPostersGroupsEvent();
}

class GetPostersAlertsEvent extends PostersLicenseEvent {
  const GetPostersAlertsEvent();
}

class DeleteLicenseFromRequestEvent extends PostersLicenseEvent {
  final int index;
  const DeleteLicenseFromRequestEvent({required this.index});
}

class DeletePosterEvent extends PostersLicenseEvent {
  final int index;
  const DeletePosterEvent({required this.index});
}

class ApplyLicenseEvent extends PostersLicenseEvent {
  const ApplyLicenseEvent();
}

class DeletePosterRequestEvent extends PostersLicenseEvent {
  const DeletePosterRequestEvent();
}

class ToggleAgreementEvent extends PostersLicenseEvent {
  final bool? agreement;
  const ToggleAgreementEvent({this.agreement});
}

class GetMoreLicensesEvent extends PostersLicenseEvent {
  const GetMoreLicensesEvent();
}
