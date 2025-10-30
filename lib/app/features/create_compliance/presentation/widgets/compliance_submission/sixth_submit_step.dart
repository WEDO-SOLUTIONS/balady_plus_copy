import 'dart:io';
import 'dart:typed_data';

import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/bloc/compliance_bloc.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/bloc/compliance_event.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/bloc/compliance_state.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/widgets/compliance_submission/previous_next_buttons.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/widgets/compliance_title_widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sentry_dio/sentry_dio.dart';

import '../../../../../core/services/global/web_service.dart';
import '../../../../../core/services/local/navigation_services.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../../../core/utils/constants/remote_config.dart';
import '../../../../../core/utils/constants/route_names.dart';
import '../../../../../core/utils/enums/app_font_weights.dart';
import '../../../../home_page/presentation/widgets/home_tag.dart';
import '../../../../objectable_transactions/presentation/widgets/objection_feedback_details_dialog.dart';
import '../../../../transaction_inquiry/customer_voice_exports.dart';
import '../../../domain/entities/comliance_request_details.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

class SixthComplianceSubmitStep extends StatelessWidget {
  const SixthComplianceSubmitStep({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ComplianceBloc, ComplianceState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextFieldWidget(
                  label: 'notes'.tr(),
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp('[٠١٢٣٤٥٦٧٨٩]')),
                  ],
                  onChanged: (String? t) {
                    context
                        .read<ComplianceBloc>()
                        .add(ChangeApplicantNotesEvent(text: t));
                  },
                  maxLines: 4,
                ),
                SizedBox(
                  height: 32,
                ),
                if ((state.requestDetails?.applicantNotes?.length ?? 0) >
                    0) ...[
                  CustomTextWidget(
                    'prevoius_notes'.tr(),
                    fontSize: 14,
                    fontWeight: AppFontWeight.bold,
                    fontColor: AppColor.blackModern800Light,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    child: MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: ListView.builder(
                        itemCount: state.requestDetails?.applicantNotes?.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (ctx, index) {
                          return NoteItemWidget(
                              item: state
                                  .requestDetails!.applicantNotes![index]!);
                        },
                      ),
                    ),
                  )
                ],
                SizedBox(
                  height: 32,
                ),
                PreviousNextButtons()
              ],
            ),
          ),
        );
      },
    );
  }
}

class AttachmentListWidget extends StatelessWidget {
  final List<AttachmentData> attachments;
  final bool showDelete;
  final Function(int index, String filePath, String fileName, String base64)
      saveFile;
  final Function(int index) deleteFile;

  const AttachmentListWidget(
      {Key? key,
      required this.attachments,
      required this.saveFile,
      required this.deleteFile,
      this.showDelete = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ListView.builder(
        itemCount: attachments.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (ctx, index) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
            child: AttachmentWidget(
              fileIndex: index,
              title: attachments[index].title,
              isRequired: attachments[index].isRequired,
              path: attachments[index].filePath,
              fileName: attachments[index].fileName,
              onPress: () {
                if (attachments[index].filePath != null &&
                    !attachments[index].filePath!.startsWith("http"))
                  CommonFunctions.openFile(File(attachments[index].filePath!));
                else if (attachments[index].filePath != null &&
                    attachments[index].filePath!.startsWith("http")) {
                  showFile(attachments[index].filePath ?? "",
                      attachments[index].fileName!);
                }
              },
              hint: attachments[index].hint,
              enableButton: (status) {},
              saveFile: saveFile,
              deleteFile: deleteFile,
              showDelete: showDelete,
            ),
          );
        },
      ),
    );
  }

  void showFile(String fileUrl, String fileName) async {
    try {
      if (fileName.toLowerCase().contains(".png") ||
          fileName.toLowerCase().contains(".jpeg") ||
          fileName.toLowerCase().contains(".jpg")) {
        NavigationService.navigatorKey.currentState!
            .pushNamed(RouteName.apigeeImageFullScreen, arguments: fileUrl);
      } else {
        try {
          EasyLoading.show();
          File fileDownloaded = await createFileOfPdfUrl(fileUrl, fileName);
          EasyLoading.dismiss();

          if (fileName.toLowerCase().contains(".pdf")) {
            Uint8List bytes = fileDownloaded.readAsBytesSync();

            Navigator.push(
                NavigationService.navigatorKey.currentContext!,
                MaterialPageRoute(
                    builder: (context) => PDFViewer(
                          file: bytes,
                          title: fileName,
                        )));
          } else {
            OpenFile.open(fileDownloaded.path);
          }
        } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
          EasyLoading.dismiss();
        }
      }
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      EasyLoading.dismiss();
    }
  }

  Future<File> createFileOfPdfUrl(String fileUrl, String fileName) async {
    final url = fileUrl;
    Dio dio = Dio();
    dio.options.baseUrl = RemoteConfig.apigeeURL;
    dio.options.connectTimeout = const Duration(milliseconds: 60000);

    dio.options.receiveTimeout = const Duration(milliseconds: 60000);

    dio.options.sendTimeout = const Duration(milliseconds: 60000);
    dio.addSentry();

    dio.options.responseType = ResponseType.bytes;
    dio.interceptors.add(AppInterceptors());
    ;
    Response r = await WebService(dio: dio).dio.getUri(Uri.parse(url));

    String dir = (await getTemporaryDirectory()).path;
    File file = new File('$dir/$fileName');
    await file.writeAsBytes(r.data);
    return file;
  }
}

class NoteItemWidget extends StatelessWidget {
  final ApplicantNote item;
  const NoteItemWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
          color: Color(0xAACDE2E2), borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomTextWidget(
                item.author ?? "",
                fontColor: AppColor.primary700Light,
                fontWeight: AppFontWeight.bold,
                fontSize: 12,
              ),
              CustomTextWidget(
                item.date ?? "",
                fontColor: AppColor.blackModern500Light,
                fontWeight: AppFontWeight.bold,
                fontSize: 14,
              )
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          CustomTextWidget(
            item.note ?? "",
            fontColor: AppColor.blackModern600Light,
            fontWeight: AppFontWeight.medium,
            fontSize: 12,
            maxLines: 1000,
          ),
          const SizedBox(
            height: 16,
          ),
          if (item.noteAttachment?.attachUrl != null)
            ComplainceAttachment(
              url: item.noteAttachment?.attachUrl?.toString() ?? "",
              name: item.noteAttachment?.name.toString(),
            ),
        ],
      ),
    );
  }
}

class ComplainceAttachment extends StatelessWidget {
  final String url;
  final String? name;
  const ComplainceAttachment({super.key, required this.url, this.name});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          CommonFunctions.showApigeeFile(
            url,
            name ?? DateTime.now().millisecond.toString(),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(top: 16),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Color(0x80E6EFEF)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomTextWidget(
                "obkection_enquiry_show_file".tr(),
                fontColor: AppColor.primary900Light,
                fontSize: 12,
                fontWeight: AppFontWeight.bold,
              ),
              const SizedBox(
                height: 32,
              ),
              const CustomSvgIconWidget(IconPath.receiveSquare, iconSize: 24.0),
            ],
          ),
        ));
  }
}
