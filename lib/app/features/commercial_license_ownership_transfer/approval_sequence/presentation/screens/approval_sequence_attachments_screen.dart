import 'dart:io';
import 'dart:typed_data';

import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../../core/utils/common_functions.dart';
import '../../../../../core/utils/enums/bloc_status.dart';
import '../../../../Commercial_license_transfer/persentation/interface/step_interface.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';

import 'package:dio/dio.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sentry_dio/sentry_dio.dart';

import '../../../../../core/services/global/web_service.dart';
import '../../../../../core/services/local/navigation_services.dart';
import '../../../../../core/utils/constants/remote_config.dart';
import '../../../../../core/utils/constants/route_names.dart';
import '../../../../comercial_license_renew/presentation/commercial_license/widgets/cr_header_desc.dart';
import '../../../../commercial_license/presentation/commercial_license/blocs/commercial_license_bloc.dart';
import '../../../../commercial_license/presentation/commercial_license/widgets/previous_next_button.dart';
import '../../../../commercial_license/presentation/step5/bloc/cr_step5_attachment_data_cubit.dart';
import '../../../../commercial_license/presentation/step5/widgets/credence_components.dart';
import '../../../../transaction_inquiry/customer_voice_exports.dart';
import '../blocs/request_approval_sequence_cubit.dart';
import '../widgets/AttachmentComponents.dart';

class ApprovalSequenceAttachmentsScreen extends StatefulWidget {
  StepInterface stepInterface;

  ApprovalSequenceAttachmentsScreen({Key? key, required this.stepInterface})
      : super(key: key);

  @override
  State<ApprovalSequenceAttachmentsScreen> createState() =>
      _ApprovalSequenceAttachmentsScreenState();
}

class _ApprovalSequenceAttachmentsScreenState
    extends State<ApprovalSequenceAttachmentsScreen> {
  @override
  void initState() {
    // TODO: implement initState

    context.read<RequestApprovalSequenceCubit>().InitAttachmentForm();
    Future.microtask(() {

      context.read<RequestApprovalSequenceCubit>().getAttachments();
    });

    //context.read<RequestApprovalSequenceCubit>().getCredneces();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RequestApprovalSequenceCubit, RequestApprovalSequenceState>(
      listener: (context, state) {
        // if ((state as AttachmentState).status == BlocStatus.failure) {
        //   CommonFunctions.showError((state as AttachmentState).errorMessage ?? "");
        // }
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
                            header: "step11title3".tr(),
                            desc: "",
                          ),
                          const SizedBox(height: 12),
                          if ((state as AttachmentState).attachments != null)
                            AttachmentListWidget(
                              attachments: (state as AttachmentState).attachments ?? [],
                              deleteFile: (int index) {
                                context
                                    .read<RequestApprovalSequenceCubit>()
                                    .deleteFile(index);
                              },
                              saveFile: (int index, String filePath,
                                  String fileName, String base64) {
                                context
                                    .read<RequestApprovalSequenceCubit>()
                                    .saveFile(
                                        index: index,
                                        fileName: fileName,
                                        fileBase64: base64,
                                        filePath: filePath);
                              },
                            ),
                          if ((state as AttachmentState).attachmentStatus == BlocStatus.failure)
                            RetryWidget(
                              onRetry: () {
                                context
                                    .read<RequestApprovalSequenceCubit>()
                                    .getAttachments();
                                // context
                                //     .read<RequestApprovalSequenceCubit>()
                                //     .getCredneces();
                              },
                            ),

                          const SizedBox(
                            height: 8,
                          ),
                          //const AttachmentComponents(),
                        ],
                      ),
                    ),
                  ),
                ),


                Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(36),
                        topRight: Radius.circular(36),
                      ),
                      color: Colors.white),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 26),
                  child: ElevatedButtonWidget.next(
                    onPressed: () {


                      context.read<RequestApprovalSequenceCubit>().submitApprove()
                          .then((requestId) => {


                        if(requestId >0)
                          {

                           Navigator.of(context).pop(true),
                            Navigator.of(context).pushNamed(RouteName.SucessfullScreen, arguments: "$requestId",)
                          }



                      }
                      );


                    },
                  ),
                ),
              ],
            ),
            if ((state as AttachmentState).attachmentStatus.isSubmissionLoading ||
                (state as AttachmentState).status.isSubmissionLoading ||
                (state as AttachmentState).credenceStatus.isSubmissionLoading)
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
            .pushNamed(RouteName.apigeeImageFullScreen, arguments: fileUrl);
      } else {
        try {
          EasyLoading.show();
          File fileDownloaded = await createFileOfPdfUrl(fileUrl, fileName);
          EasyLoading.dismiss();

          if (fileName.toLowerCase().contains(".pdf")) {
            Uint8List bytes = fileDownloaded.readAsBytesSync();
//Navigator
            NavigationService.navigatorKey.currentState!.push(MaterialPageRoute(
                builder: (context) => PDFViewer(
                      file: bytes,
                      title: fileName,
                    )));
          } else {
            OpenFile.open(fileDownloaded.path);
          }
        } catch (ex) {
          EasyLoading.dismiss();

          print(ex);
        }
      }
    } catch (ex) {
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
