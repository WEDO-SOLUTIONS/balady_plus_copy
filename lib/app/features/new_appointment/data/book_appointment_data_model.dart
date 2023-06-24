import 'package:file_picker/file_picker.dart' show PlatformFile;

import '../../../core/utils/constants/constants.dart';

class BookAppointmentDataModel {
  final String? municipality;
  final String? municipal;
  final String? desiredService;
  final String? serviceNumber;
  final String? notes;
  final String? type;
  final PlatformFile? attachment;
  final String? specialNeeds;
  final String? date;
  final String? time;

  BookAppointmentDataModel({
    this.municipality,
    this.municipal,
    this.desiredService,
    this.serviceNumber,
    this.notes,
    this.type,
    this.attachment,
    this.specialNeeds,
    this.date,
    this.time,
  });

  factory BookAppointmentDataModel.fromJson(Map<String, dynamic> json) =>
      BookAppointmentDataModel(
        municipality:
            json[Constants.bookAppointmentInfoMunicipalityDropdownKey],
        municipal: json[Constants.bookAppointmentInfoMunicipalDropdownKey],
        desiredService:
            json[Constants.bookAppointmentInfoDesiredServiceDropdownKey],
        serviceNumber: json[Constants.bookAppointmentInfoServiceNumberKey],
        notes: json[Constants.bookAppointmentInfoNotesKey],
        type: json[Constants.bookAppointmentInfoTypeKey],
        attachment: json[Constants.bookAppointmentInfoAttachmentKey],
        specialNeeds: json[Constants.bookAppointmentInfoSpecialNeedsKey],
        date: json[Constants.bookAppointmentDateKey],
        time: json[Constants.bookAppointmentTimeKey],
      );

  Map<String, dynamic> toJson() => {
        Constants.bookAppointmentInfoMunicipalityDropdownKey: municipality,
        Constants.bookAppointmentInfoMunicipalDropdownKey: municipal,
        Constants.bookAppointmentInfoDesiredServiceDropdownKey: desiredService,
        Constants.bookAppointmentInfoServiceNumberKey: serviceNumber,
        Constants.bookAppointmentInfoNotesKey: notes,
        Constants.bookAppointmentInfoTypeKey: type,
        Constants.bookAppointmentInfoAttachmentKey: attachment,
        Constants.bookAppointmentInfoSpecialNeedsKey: specialNeeds,
        Constants.bookAppointmentDateKey: date,
        Constants.bookAppointmentTimeKey: time,
      };
}
