import 'dart:io';
import 'dart:typed_data';
import 'package:localize_and_translate/localize_and_translate.dart';

import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import '../../../../../../features/_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../../commercial_license_exports.dart';
import '../bloc/cr_step11_attachment_data_cubit.dart';
import 'package:dio/dio.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sentry_dio/sentry_dio.dart';

import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:balady_plus/app/core/utils/constants/remote_config.dart';
import 'package:balady_plus/app/commercial_model/commercial_routes/commercial_route_names.dart';
import 'package:balady_plus/app/features/transaction_inquiry/customer_voice_exports.dart';

import 'package:balady_plus/app/events_logs/balady_logs.dart';


class CRStep11AttachmentData extends StatefulWidget {
  const CRStep11AttachmentData({Key? key}) : super(key: key);

  @override
  State<CRStep11AttachmentData> createState() => _CRStep11AttachmentDataState();
}

class _CRStep11AttachmentDataState extends State<CRStep11AttachmentData> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    context.read<CRStep11AttachmentCubit>().getAttachments();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CRStep11AttachmentCubit, CRStep11AttachmentState>(
      listener: (context, state) {
        if (state.status == BlocStatus.failure)
          CommonFunctions.showError(state.errorMessage ?? "");
      },
      builder: (context, state) {
        return Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CRHeaderDesc(
                            maxLines: null,
                            textHeight: 1.5,
                            header: "step5title".tr(),
                            desc: "",
                          ),
                          const SizedBox(height: 12),
                          if (state.attachments != null)
                            AttachmentListWidget(
                              attachments: state.attachments ?? [],
                              deleteFile: (int index) {
                                context
                                    .read<CRStep11AttachmentCubit>()
                                    .deleteFile(index);
                              },
                              saveFile: (int index, String filePath,
                                  String fileName, String base64) {
                                context
                                    .read<CRStep11AttachmentCubit>()
                                    .saveFile(
                                        index: index,
                                        fileName: fileName,
                                        fileBase64: base64,
                                        filePath: filePath);
                              },
                            ),
                          UndertakingWidget(
                            text: "posters_agreement_title".tr(),
                            desc: "posters_agreement_desc".tr(),
                            onChange: (value) {
                              context
                                  .read<CRStep11AttachmentCubit>()
                                  .updateAgreement(value);
                            },
                            initialValue: state.attachmentAgreement ?? false,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                (state.attachmentStatus.isSubmissionLoading ||
                    state.status.isSubmissionLoading)
                    ? const Center(child: CustomCircularLoadingWidget())
                    :  CRPreviousNextButtons(
                    onPressed: () {
                      context.read<CRStep11AttachmentCubit>().save();
                    },
                    isBtnDisabled: state.attachmentAgreement != true),
              ],
            ),
            if (state.attachmentStatus.isSubmissionLoading ||
                state.status.isSubmissionLoading)
              const CustomCircularLoadingWidget(),
          ],
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
      print("HFRR");
      if (fileName.toLowerCase().contains(".png") ||
          fileName.toLowerCase().contains(".jpeg") ||
          fileName.toLowerCase().contains(".jpg")) {
        //MM
        print("HEETT");
        NavigationService.navigatorKey.currentState!
            .pushNamed(CommercialRouteName.apigeeImageFullScreen, arguments: fileUrl);
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

          print(error);
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
