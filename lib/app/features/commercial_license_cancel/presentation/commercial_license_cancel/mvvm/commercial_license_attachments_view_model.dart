import 'dart:async';

import 'package:balady_plus/app/core/base/base_view_model.dart';
import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:balady_plus/app/core/utils/constants/apis/api_info.dart';
import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:balady_plus/app/features/create_compliance/data/models/comliance_request_details_model.dart';


class CommercialLicenseAttachmentsViewModel extends BaseViewModel {
  final WebService webService;

  List<AttachmentModel> attachments = [];
  final int licenseId;


  bool fileDone = true;

  CommercialLicenseAttachmentsViewModel(
      {required this.webService, required this.licenseId}) {
    getCommercialLicenseCancelAttachments(licenseId);
  }

  Future<void> getCommercialLicenseCancelAttachments(int licenseId) async {
    try {
      isLoading = true;
      notifyListeners();
      var response = await webService.dio
          .get(ApiUrl.getLicenseAttachments(licenseId));
      final data = response.data;
      final result = ResponseBodyModel.fromMap(data).data?.result;
      attachments = result
          .map<AttachmentModel>(
              (e) {
                AttachmentModel attachment = AttachmentModel.fromJson(e as Map<String, dynamic>);
                // if((attachment.isMandatory ?? false) && !(attachment.updatable ?? false)) {
                //   fileDone = false;
                // }
                return attachment;
              } )
          .toList();
    } catch (e) {
      showError(e.toString());
    }
    isLoading = false;
    notifyListeners();
  }

}
