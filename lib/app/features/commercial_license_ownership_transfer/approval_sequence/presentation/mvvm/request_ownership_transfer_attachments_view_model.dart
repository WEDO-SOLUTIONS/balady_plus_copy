import 'dart:async';

import 'package:balady_plus/app/core/base/base_view_model.dart';
import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/apis/api_info.dart';
import 'package:balady_plus/app/features/_shared_feature_/data/entities/file_data_item.dart';
import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:balady_plus/app/features/create_compliance/data/models/comliance_request_details_model.dart';
import 'package:dio/dio.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart' as http;

class RequestOwnerShipTransferAttachmentsViewModel extends BaseViewModel {
  final WebService webService;

  List<AttachmentModel> attachments = [];
  final int requestId;

  bool fileDone = true;

  RequestOwnerShipTransferAttachmentsViewModel(
      {required this.webService, required this.requestId}) {
    getCommercialLicenseTransferAttachments();
  }

  Future<void> getCommercialLicenseTransferAttachments() async {
    Response? response;
    try {
      isLoading = true;
      notifyListeners();
      response = await webService.dio.get(
        ApiUrl.transferRequestAttachments(requestId),
      );
      final data = response.data;
      final result = ResponseBodyModel.fromMap(data).data?.result;
      fileDone = true;
      attachments = result.map<AttachmentModel>((e) {
        AttachmentModel attachment =
            AttachmentModel.fromJson(e as Map<String, dynamic>);
        if ((attachment.isMandatory ?? false) &&
            !(attachment.attached ?? false)) {
          fileDone = false;
        }
        return attachment;
      }).toList();
    } on Exception catch (exception) {
      CommonFunctions.sendEvent(
        dioError: exception is DioException ? exception : null,
        response: response,
        ex: exception,
      );
    } catch (exception) {
      CommonFunctions.sendEvent(
        dioError: null,
        response: response,
        ex: Exception(exception.toString()),
      );
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> uploadCommercialLicenseTransferAttachments(
    FileDataItem file,
    int attachTypeId,
  ) async {
    Response? response;
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
      response = await webService.dio.post(
        ApiUrl.commercialLicenseOwnershipServicesUploadAttachments(
          requestId,
          attachTypeId,
        ),
        data: formData,
        options: Options(
          headers: {
            "fileContentType": contentTyp,
            "x-channel-id": "mobile"
          },
        ),
      );
      await getCommercialLicenseTransferAttachments();
    } on Exception catch (exception) {
      CommonFunctions.sendEvent(
        dioError: exception is DioException ? exception : null,
        response: response,
        ex: exception,
      );
      showError(exception.toString());
    } catch (exception) {
      CommonFunctions.sendEvent(
        dioError: null,
        response: response,
        ex: Exception(exception.toString()),
      );
      showError(exception.toString());
    }
    if (isLoading) {
      isLoading = false;
      notifyListeners();
    }
  }
}
