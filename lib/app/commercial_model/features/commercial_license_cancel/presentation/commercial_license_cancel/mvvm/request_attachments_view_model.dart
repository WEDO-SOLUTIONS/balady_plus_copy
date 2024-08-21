import 'dart:async';

import 'package:balady_plus/app/core/base/base_view_model.dart';
import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/data/entities/file_data_item.dart';
import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:balady_plus/app/features/create_compliance/data/models/comliance_request_details_model.dart';
import 'package:dio/dio.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart' as http;
import 'package:balady_plus/app/events_logs/balady_logs.dart';
import 'package:balady_plus/app/commercial_model/commercial_model_end_points.dart';

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
    Response? response;
    try {
      isLoading = true;
      notifyListeners();
      response = await webService.dio.get(
        CommercialModelEndPoints.commercialLicenseCancelAttachments(requestId),
      );
      final data = response.data;
      final result = ResponseBodyModel.fromMap(data).data?.result;
      attachments = result.map<AttachmentModel>((e) {
        AttachmentModel attachment =
            AttachmentModel.fromJson(e as Map<String, dynamic>);
        if ((attachment.isMandatory ?? false) &&
            !(attachment.updatable ?? false)) {
          fileDone = false;
        }
        return attachment;
      }).toList();
    } on Exception catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> uploadCommercialLicenseCancelAttachments(
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
        CommercialModelEndPoints.commercialLicenseCancelUploadAttachments(
          requestId,
          attachTypeId,
        ),
        data: formData,
        options: Options(
          headers: {
            "fileContentType": contentTyp,
          },
        ),
      );
      await getCommercialLicenseCancelAttachments(requestId);
    } on Exception catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      showError(error.toString());
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      showError(error.toString());
    }
    if (isLoading) {
      isLoading = false;
      notifyListeners();
    }
  }
}
