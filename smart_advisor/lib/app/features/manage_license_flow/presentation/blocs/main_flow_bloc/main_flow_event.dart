part of 'main_flow_bloc.dart';

abstract class ManageMainFlowEvent extends Equatable {
  const ManageMainFlowEvent();

  @override
  List<Object?> get props => [];
}

class NextScreenEvent extends ManageMainFlowEvent {
  const NextScreenEvent();
}

class PrevScreenEvent extends ManageMainFlowEvent {
  const PrevScreenEvent();
}

class ChangeValueEvent extends ManageMainFlowEvent {
  final int? currentPagesNumber;
  final bool? isLastRenewPage;
  final bool? isLastEditPage;
  final bool? isLastCancelPage;
  final bool? isLastTransfarPage;
  final int? step1User;
  final int? actionNumber;
  final int? editSelection;
  final LookUpItem? selectedActivity;
  final String? cr;

  const ChangeValueEvent(
      {this.currentPagesNumber,
      this.step1User,
      this.isLastRenewPage = false,
      this.isLastEditPage = false,
      this.isLastCancelPage = false,
      this.isLastTransfarPage = false,
      this.editSelection,
      this.actionNumber,
      this.selectedActivity,
      this.cr});
}

class GetDelegatorsEvent extends ManageMainFlowEvent {
  const GetDelegatorsEvent();
}

class GetLicensesEvent extends ManageMainFlowEvent {
  final String licenseType;
  const GetLicensesEvent({required this.licenseType});
}

class SelectDelegatorEvent extends ManageMainFlowEvent {
  final DelegatorEntity delegator;
  const SelectDelegatorEvent({required this.delegator});
}

class SelectLicenseEvent extends ManageMainFlowEvent {
  final LicensesResponseItem license;
  const SelectLicenseEvent({required this.license});
}

class GetRegulationsEvent extends ManageMainFlowEvent {
  GetRegulationsEvent();
}

class GetEntityActivityDetailsEvent extends ManageMainFlowEvent {
  GetEntityActivityDetailsEvent();
}

class GetViolationsListEvent extends ManageMainFlowEvent {
  GetViolationsListEvent();
}

class GetViolationDetailsEvent extends ManageMainFlowEvent {
  EntityViolationActivityModel item;
  GetViolationDetailsEvent({required this.item});
}

class GetViolationVD extends ManageMainFlowEvent {
  GetViolationVD();
}

class GetActivityInfoDetails extends ManageMainFlowEvent {
  GetActivityInfoDetails();
}

class GetGISDataEvent extends ManageMainFlowEvent {
  final double lat;
  final double lon;

  const GetGISDataEvent({required this.lat, required this.lon});
}

class SaveRenewDraft extends ManageMainFlowEvent {
  const SaveRenewDraft();
}

class SaveCencelDraft extends ManageMainFlowEvent {
  const SaveCencelDraft();
}

class GetAddetionalActivites extends ManageMainFlowEvent {
  const GetAddetionalActivites();
}

class AddAddetionalActivityItemEvent extends ManageMainFlowEvent {
  final AddetionalActivityItem addetionalActivityItem;
  const AddAddetionalActivityItemEvent({required this.addetionalActivityItem});
}

class UpdatePermitsInTransferEvent extends ManageMainFlowEvent {
  final int id;
  const UpdatePermitsInTransferEvent({required this.id});
}
