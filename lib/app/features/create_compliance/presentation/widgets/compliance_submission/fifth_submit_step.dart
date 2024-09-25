import 'dart:io';
import 'dart:typed_data';

import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/bloc/compliance_bloc.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/bloc/compliance_event.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/bloc/compliance_state.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/widgets/compliance_submission/previous_next_buttons.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/widgets/compliance_title_widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sentry_dio/sentry_dio.dart';

import '../../../../../core/services/global/web_service.dart';
import '../../../../../core/services/local/navigation_services.dart';
import '../../../../../core/utils/constants/remote_config.dart';
import '../../../../../core/utils/constants/route_names.dart';
import '../../../../transaction_inquiry/customer_voice_exports.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

class FifthComplianceSubmitStep extends StatelessWidget {
  const FifthComplianceSubmitStep({super.key});

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
                ComplianceSubmitTitle(
                  title: 'compliance_complain_title'.tr(),
                  subtitle: '',
                ),
                if (state.attachments != null)
                  AttachmentListWidget(
                    attachments: state.attachments ?? [],
                    deleteFile: (int index) {
                      context
                          .read<ComplianceBloc>()
                          .add(DeleteFileEvent(index: index));

                      //  model.attachments[index].fileName = null;
                      //   model.attachments[index].filePath = null;
                      //    model.attachments[index].base64 = null;
                      //     model.validateForm();
                    },
                    saveFile: (int index, String filePath, String fileName,
                        String base64) {
                      context.read<ComplianceBloc>().add(SaveFileEvent(
                          index: index,
                          fileName: fileName,
                          base64: base64,
                          filePath: filePath));
                      //   model.attachments[index].fileName = fileName;
                      //    model.attachments[index].filePath = filePath;
                      //    model.attachments[index].base64 = base64;
                      ///     model.validateForm();
                      //     setState(() {});
                      // model.notifyListeners();
                    },
                  ),
                SizedBox(
                  height: 16,
                ),
                /* SizedBox(
                  height: 32,
                ),
                CustomTextWidget(
                  'compliance_notes_title'.tr(),
                  textStyle: AppStyle.complianceDocumentTitleStyle,
                ),
                SizedBox(
                  height: 6,
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        width: 2,
                        color: AppColor.blueSkyLight800,
                      )),
                  child: CustomTextWidget(
                    'comliance_message_hint'.tr(),
                    textStyle: AppStyle.complianceSubtitleStyle,
                    textAlign: TextAlign.right,
                    maxLines: 4,
                  ),
                ),*/
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
