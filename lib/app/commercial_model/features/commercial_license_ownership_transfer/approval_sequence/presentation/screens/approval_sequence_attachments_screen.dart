import 'package:balady_plus/app/commercial_model/features/commercial_debts/data/models/commercial_debts_steps.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_debts/presentation/bloc/check_debts/commercial_check_debts_cubit.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_debts/presentation/pages/check_debts/commercial_debts_screen.dart';
import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/commercial_model/commercial_routes/commercial_route_names.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import 'package:balady_plus/app/features/_shared_feature_/data/entities/file_data_item.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_ownership_transfer/approval_sequence/presentation/blocs/request_approval_sequence_cubit.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_ownership_transfer/approval_sequence/presentation/mvvm/request_ownership_transfer_attachments_view_model.dart';
import 'package:balady_plus/app/features/objectable_transactions/presentation/widgets/create_objection_page/objection_reason_attachment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import '../../../old_owner_transfer/persentation/interface/step_interface.dart';

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    RequestOwnerShipTransferAttachmentsViewModel viewModel =
        context.watch<RequestOwnerShipTransferAttachmentsViewModel>();
    RequestApprovalSequenceCubit bloc =
        context.read<RequestApprovalSequenceCubit>();

    return CommercialDebtsScreen(
      transactionType: TransactionType.REQUEST,
      transactionId: bloc.requestNumber!,
      steps: const [OwnershipTransferSteps.submitSteps],
      serviceId: CommercialLicenseServiceId.ownershipTransferCommercialLicense,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    Consumer<RequestOwnerShipTransferAttachmentsViewModel>(
                      builder: (context, provider, child) {
                        return !provider.isLoading
                            ? Column(
                                children: provider.attachments
                                    .map(
                                      (attachment) => Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 16),
                                          CustomTextWidget(
                                            attachment.name ?? '',
                                            fontColor:
                                                AppColor.blackModern700Light,
                                            fontSize: 16,
                                            fontWeight: AppFontWeight.bold,
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              FileDataItem? file =
                                                  await CommonFunctions
                                                      .pickFile(context);
                                              if (file != null) {
                                                if ((file.sizeInMB * 1000) <=
                                                    (attachment.maxSize ?? 0)) {
                                                  provider
                                                      .uploadCommercialLicenseTransferAttachments(
                                                    file,
                                                    attachment.id!,
                                                  );
                                                } else {
                                                  CommonFunctions.showError(
                                                      "file_max_size".tr());
                                                }
                                              }
                                            },
                                            child: Container(
                                              margin:
                                                  const EdgeInsets.only(top: 6),
                                              padding: const EdgeInsets.all(16),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(16),
                                                ),
                                                border: Border.all(
                                                  color:
                                                      AppColor.primary800Light,
                                                ),
                                                color: Colors.transparent,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const CustomSvgIconWidget(
                                                    IconPath.add,
                                                    iconSize: 20,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  CustomTextWidget(
                                                    'attachment'.tr(),
                                                    fontColor: AppColor
                                                        .primary800Light,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        AppFontWeight.bold,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          attachment.fileName != null
                                              ? ObjectionReasonAttachment(
                                                  fileName:
                                                      attachment.fileName ?? "",
                                                  filePath:
                                                      attachment.attachUrl ??
                                                          "",
                                                  showDelete: false,
                                                  onDelete: () {},
                                                )
                                              : const SizedBox(),
                                          const SizedBox(height: 6),
                                          CustomTextWidget(
                                            '${'attachment_message_typ'.tr()} ${attachment.allowedFilesExtension ?? ''} ${'attachment_message_size'.tr()} ${(attachment.maxSize ?? 0) ~/ 1000} MB',
                                            fontColor:
                                                AppColor.blackModern700Light,
                                            fontSize: 16,
                                            fontWeight: AppFontWeight.bold,
                                            maxLines: 3,
                                          ),
                                        ],
                                      ),
                                    )
                                    .toList(),
                              )
                            : const ShimmerEffectWidget(
                                height: 65,
                                borderRadius: 8,
                              );
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: BlocBuilder<RequestApprovalSequenceCubit,
                RequestApprovalSequenceState>(builder: (context, state) {
              return state is LoadingState ||
                      ((state is DTOState) &&
                          (state as DTOState).status == BlocStatus.loading)
                  ? const CustomCircularLoadingWidget()
                  : Selector<RequestOwnerShipTransferAttachmentsViewModel,
                      bool>(
                      selector: (_, provider) => provider.isLoading,
                      builder: (_, isLoading, child) {
                        return EnhancedCustomElevatedButtonWidget(
                          btnColor: !viewModel.fileDone
                              ? AppColor.black200
                              : AppColor.primary900Light,
                          btnTextColor: !viewModel.fileDone
                              ? AppColor.black400
                              : AppColor.white,
                          btnPressed: !viewModel.fileDone
                              ? null
                              : () {
                                  bloc.submitApprove().then(
                                        (requestId) => {
                                          if (requestId > 0)
                                            {
                                              Navigator.of(context).pop(true),
                                              Navigator.of(context).pushNamed(
                                                CommercialRouteName
                                                    .SucessfullScreen,
                                                arguments: {
                                                  "requestId": "$requestId",
                                                  "isFromRequest": false
                                                },
                                              )
                                            }
                                        },
                                      );
                                },
                          btnRadius: 8,
                          btnText: ("submit_order").tr(),
                          btnTextSize: 16,
                          btnTextWeight: AppFontWeight.bold,
                          btnHeight: 56,
                        );
                      },
                    );
            }),
          ),
          const SizedBox(height: 20)
        ],
      ),
    );
  }
}

// class AttachmentListWidget extends StatelessWidget {
//   final List<AttachmentData> attachments;
//   final bool showDelete;
//   final Function(int index, String filePath, String fileName, String base64)
//       saveFile;
//   final Function(int index) deleteFile;
//
//   const AttachmentListWidget(
//       {Key? key,
//       required this.attachments,
//       required this.saveFile,
//       required this.deleteFile,
//       this.showDelete = true})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return MediaQuery.removePadding(
//       context: context,
//       removeTop: true,
//       child: ListView.builder(
//         itemCount: attachments.length,
//         shrinkWrap: true,
//         physics: const NeverScrollableScrollPhysics(),
//         itemBuilder: (ctx, index) {
//           return Container(
//             margin: const EdgeInsets.symmetric(vertical: 20),
//             child: AttachmentWidget(
//               fileIndex: index,
//               title: attachments[index].title,
//               isRequired: attachments[index].isRequired,
//               path: attachments[index].filePath,
//               fileName: attachments[index].fileName,
//               onPress: () {
//                 if (attachments[index].filePath != null &&
//                     !attachments[index].filePath!.startsWith("http"))
//                   CommonFunctions.openFile(File(attachments[index].filePath!));
//                 else if (attachments[index].filePath != null &&
//                     attachments[index].filePath!.startsWith("http")) {
//                   showFile(attachments[index].filePath ?? "",
//                       attachments[index].fileName!);
//                 }
//               },
//               hint: attachments[index].hint,
//               enableButton: (status) {},
//               saveFile: saveFile,
//               deleteFile: deleteFile,
//               showDelete: showDelete,
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   void showFile(String fileUrl, String fileName) async {
//     try {
//       print("HFRR");
//       if (fileName.toLowerCase().contains(".png") ||
//           fileName.toLowerCase().contains(".jpeg") ||
//           fileName.toLowerCase().contains(".jpg")) {
//         //MM
//         print("HEETT");
//         NavigationService.navigatorKey.currentState!
//             .pushNamed(CommercialRouteName.apigeeImageFullScreen, arguments: fileUrl);
//       } else {
//         try {
//           EasyLoading.show();
//           File fileDownloaded = await createFileOfPdfUrl(fileUrl, fileName);
//           EasyLoading.dismiss();
//
//           if (fileName.toLowerCase().contains(".pdf")) {
//             Uint8List bytes = fileDownloaded.readAsBytesSync();
// //Navigator
//             NavigationService.navigatorKey.currentState!.push(MaterialPageRoute(
//                 builder: (context) => PDFViewer(
//                       file: bytes,
//                       title: fileName,
//                     )));
//           } else {
//             OpenFile.open(fileDownloaded.path);
//           }
//         } catch (error, stackTrace) {
//       LogsViewModel().sendEventFromModel(
//         event: ErrorExceptionModel(
//           nameEvent: EventsName.handledException,
//           message: error.toString(),
//           stackTrace: stackTrace.toString(),
//         ),
//       );
//           EasyLoading.dismiss();
//
//           print(error);
//         }
//       }
//     } catch (error, stackTrace) {
//       LogsViewModel().sendEventFromModel(
//         event: ErrorExceptionModel(
//           nameEvent: EventsName.handledException,
//           message: error.toString(),
//           stackTrace: stackTrace.toString(),
//         ),
//       );
//       EasyLoading.dismiss();
//     }
//   }
//
//   Future<File> createFileOfPdfUrl(String fileUrl, String fileName) async {
//     final url = fileUrl;
//     Dio dio = Dio();
//     dio.options.baseUrl = RemoteConfig.apigeeURL;
//     dio.options.connectTimeout = const Duration(milliseconds: 60000);
//
//     dio.options.receiveTimeout = const Duration(milliseconds: 60000);
//
//     dio.options.sendTimeout = const Duration(milliseconds: 60000);
//     dio.addSentry();
//
//     dio.options.responseType = ResponseType.bytes;
//     dio.interceptors.add(AppInterceptors());
//     ;
//     Response r = await WebService(dio: dio).dio.getUri(Uri.parse(url));
//
//     String dir = (await getTemporaryDirectory()).path;
//     File file = new File('$dir/$fileName');
//     await file.writeAsBytes(r.data);
//     return file;
//   }
// }
