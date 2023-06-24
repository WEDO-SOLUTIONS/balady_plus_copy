import 'package:balady_plus/app/features/vd/domain/entities/upload/upload_file_response.dart';

class UploadFileResponseModel extends UploadFileResponse {
  UploadFileResponseModel({super.fileId});

  factory UploadFileResponseModel.fromMap(Map<String, dynamic> json) =>
      UploadFileResponseModel(
        fileId: json["fileId"],
      );
}
