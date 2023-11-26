import 'package:balady_plus/app/features/_shared_feature_/data/entities/file_data_item.dart';
import 'package:balady_plus/app/features/ekram/data/model/apply_deceased/deceased_info_dto.dart';
import 'package:equatable/equatable.dart';
import 'package:mime/mime.dart';

class ApplyDeceasedParams {
  int? deathCityId;
  int? deathTransferStatusId;
  List<DeceasedInfoDto>? deceasedInfoDtoList;
  int? hospitalId;
  String? hospitalOtherName;
  String? locationAddress;
  String? relationship;
  FileDataItem? letter;

  ApplyDeceasedParams(
      {this.deathCityId,
      this.deathTransferStatusId,
      this.deceasedInfoDtoList,
      this.hospitalId,
      this.hospitalOtherName,
      this.locationAddress,
      this.relationship,
      this.letter});

  Map<String, dynamic> toMap() => {
        "deathCityId": deathCityId,
        "deathTransferStatusId": deathTransferStatusId,
        "deceasedInfoDtoList":
            deceasedInfoDtoList?.map((e) => e.toMap()).toList(),
        "hospitalId": hospitalId,
        "hospitalOtherName": hospitalOtherName,
        "locationAddress": locationAddress,
        "relationship": relationship,
        if (letter != null)
          "deceasedTransportRequestAttach": [
            {
              "attachTypeId": 8507,
              "contentType": lookupMimeType(letter!.filePath),
              "fileContent": letter!.fileBase64
            }
          ]
      };
}
