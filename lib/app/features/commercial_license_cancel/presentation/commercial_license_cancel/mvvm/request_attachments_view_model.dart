import 'dart:async';

import 'package:balady_plus/app/core/base/base_view_model.dart';
import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:balady_plus/app/core/utils/constants/apis/api_info.dart';
import 'package:balady_plus/app/features/_shared_feature_/data/entities/file_data_item.dart';
import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:balady_plus/app/features/create_compliance/data/models/comliance_request_details_model.dart';
import 'package:dio/dio.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart' as http;

class RequestAttachmentsViewModel extends BaseViewModel {
  final WebService webService;

  List<AttachmentModel> attachments = [];
  final int requestId;


  bool fileDone = true;

  RequestAttachmentsViewModel(
      {required this.webService, required this.requestId}) {
    getCommercialLicenseCancelAttachments(requestId);
  }

  Future<void> getCommercialLicenseCancelAttachments(int requestId) async {
    try {
      isLoading = true;
      notifyListeners();
      var response = await webService.dio
          .get(ApiUrl.commercialLicenseCancelAttachments(requestId));
      final data = response.data;
      final result = ResponseBodyModel.fromMap(data).data?.result;
      attachments = result
          .map<AttachmentModel>(
              (e) {
                AttachmentModel attachment = AttachmentModel.fromJson(e as Map<String, dynamic>);
                if((attachment.isMandatory ?? false) && !(attachment.updatable ?? false)) {
                  fileDone = false;
                }
                return attachment;
              } )
          .toList();
    } catch (e) {
      showError(e.toString());
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> uploadCommercialLicenseCancelAttachments(
      FileDataItem file, int) async {
    try {
      isLoading = true;
      notifyListeners();
      String contentTyp = lookupMimeType(file.filePath)!;
      final formData = FormData.fromMap(
        {
          "file": await MultipartFile.fromFile(
            file.filePath,
            filename: file.fileName,
            contentType: http.MediaType.parse(contentTyp),
          ),
        },
      );
      var response = await webService.dio.post(
        ApiUrl.commercialLicenseCancelUploadAttachments(
          requestId,
          1046,
        ),
        data: formData,
        options: Options(
          headers: {
            "fileContentType": contentTyp,
          },
        ),
      );
      // final data = response.data;
      // final result = ResponseBodyModel.fromMap(data).data?.result;
      await getCommercialLicenseCancelAttachments(requestId);
    } catch (e) {
      showError(e.toString());
    }
    if(isLoading) {
      isLoading = false;
      notifyListeners();
    }
  }
}
