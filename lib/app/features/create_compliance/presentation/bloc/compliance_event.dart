import 'package:balady_plus/app/features/vd/domain/entities/gis/gis_params.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/comliance_request_details.dart';
import '../../domain/entities/complinace_licenses_response.dart';
import '../../domain/entities/ownership_doc_type_response.dart';

class ComplianceEvent extends Equatable {
  const ComplianceEvent();

  @override
  List<Object> get props => [];
}

class ChangePageEvent extends ComplianceEvent {
  final int index;
  const ChangePageEvent(this.index);
}

class RadioSelectEvent extends ComplianceEvent {
  final int index;
  const RadioSelectEvent(this.index);
}

class ApplyEvent extends ComplianceEvent {
  const ApplyEvent();
}

class GetLicensesEvent extends ComplianceEvent {
  const GetLicensesEvent();
}

class GetRequestDetails extends ComplianceEvent {
  const GetRequestDetails();
}

class GetMainUsagesEvent extends ComplianceEvent {
  const GetMainUsagesEvent();
}

class GetSubUsagesEvent extends ComplianceEvent {
  final ComplinaceLookUpItem? item;
  const GetSubUsagesEvent({this.item});
}

class GetOwnerShipTypesEvent extends ComplianceEvent {
  const GetOwnerShipTypesEvent();
}

class GetEnginnerOfficesEvent extends ComplianceEvent {
  const GetEnginnerOfficesEvent();
}

class UpdateFieldsEvent extends ComplianceEvent {
  final ComplinaceLookUpItem? selectedOwnerShip;
  final ComplinaceLookUpItem? selectedMainUsage;
  final ComplinaceLookUpItem? selectedSubUsage;
  final ComplianceLisenseItem? selectedLicense;

  final String? ownershipText;
  final String? ownershipDate;
  final int? documentTypeSelection;
  final int? benificiaryTypeSelection;
  final String? mobileNumber;
  const UpdateFieldsEvent(
      {this.selectedOwnerShip,
      this.selectedMainUsage,
      this.selectedSubUsage,
      this.ownershipText,
      this.ownershipDate,
      this.documentTypeSelection,
      this.benificiaryTypeSelection,
      this.mobileNumber,
      this.selectedLicense});
}

class GoToNextPageEvent extends ComplianceEvent {
  GoToNextPageEvent();
}

class GoToPreviousPageEvent extends ComplianceEvent {
  GoToPreviousPageEvent();
}

class ChangeImtethalItemEvent extends ComplianceEvent {
  final int index;
  final EmtithalItem item;
  const ChangeImtethalItemEvent({required this.index, required this.item});
}

class SaveImtethalItemsEvent extends ComplianceEvent {
  const SaveImtethalItemsEvent();
}

class SaveFileEvent extends ComplianceEvent {
  final int index;
  final String fileName;
  final String filePath;
  final String base64;

  const SaveFileEvent(
      {required this.index,
      required this.fileName,
      required this.base64,
      required this.filePath});
}

class DeleteFileEvent extends ComplianceEvent {
  final int index;
  const DeleteFileEvent({required this.index});
}

class SubmitComplianceEvent extends ComplianceEvent {
  const SubmitComplianceEvent();
}

class SaveLocationData extends ComplianceEvent {
  const SaveLocationData();
}

class GetComplianceGISEvent extends ComplianceEvent {
  final GISParams params;
  const GetComplianceGISEvent({required this.params});
}
