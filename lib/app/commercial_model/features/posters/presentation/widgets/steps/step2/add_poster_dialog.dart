import 'dart:io';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/commercial_model/features/posters/domain/entities/poster_item.dart';
import 'package:balady_plus/app/commercial_model/features/posters/presentation/widgets/steps/step2/poster_types_dialog.dart';
import 'package:balady_plus/app/features/home_page/presentation/widgets/home_app_bar/circle_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import 'package:balady_plus/app/core/services/local/helpers.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import '../../../../../../../features/_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../../../../../../features/_shared_feature_/presentation/widgets/reload_widget.dart';
import '../../../../../../../features/_shared_feature_/presentation/widgets/texts/custom_text_field_widget.dart';
import '../../../../../../../features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../../../../../features/transaction_inquiry/presentation/widgets/request_service/attachment_widget.dart';
import '../../../../data/models/attachment_resposne_model.dart';
import '../../../../data/models/permit_poster_types_response.dart';
import '../../../../data/models/posters_upload_response_model.dart';
import '../../../blocs/posters_license_bloc.dart';

class AddPosterDialog extends StatefulWidget {
  final Function(PosterItem) onAdd;
  final PosterItem? item;
  const AddPosterDialog({super.key, required this.onAdd, this.item});

  @override
  State<AddPosterDialog> createState() => _AddPosterDialogState();
}

class _AddPosterDialogState extends State<AddPosterDialog> {
  PermitPosterTypeItem? posterType;
  String? posterName;
  double? length;
  double? width;
  int? discountPercentage;

  final TextEditingController _area = TextEditingController();

  List<PermitAttachmentItem>? attachments = [];

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      posterType = widget.item?.posterType;
      length = widget.item?.length;
      width = widget.item?.width;
      _area.text = ((length ?? 0) * (width ?? 0)).toString();
      attachments = widget.item?.attachedDocuments;
      posterName = widget.item?.name;
      discountPercentage = widget.item?.discountPercentage;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostersLicenseBloc, PostersLicenseState>(
        builder: (context, state) {
      return GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Container(
          color: AppColor.white,
          padding: const EdgeInsets.all(16),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomTextWidget(
                            Helpers.translatingWord("posters_add".tr()),
                            fontColor: AppColor.blackModern900Light,
                            fontWeight: AppFontWeight.bold,
                            maxLines: 10,
                          ),
                          InkWell(
                              onTap: () => Navigator.pop(context),
                              child: CircleIcon(
                                icon: Icons.close,
                                iconColor: AppColor.primary600Light,
                                backgroundColor:
                                    AppColor.geyser.withOpacity(0.4),
                                iconSize: 18,
                              )),
                        ]),
                    PosterDropDown(
                      onSelect: (PermitPosterTypeItem? item) async {
                        setState(() {
                          posterType = item;
                        });

                        attachments = await context
                                .read<PostersLicenseBloc>()
                                .getAttachments(posterType!.id!) ??
                            [];
                        setState(() {});
                      },
                      item: posterType,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    CustomTextFieldWidget(
                      label: "poster_name".tr(),
                      initialValue: posterName,
                      onChanged: (String? value) {
                        posterName = value;
                        setState(() {});
                      },
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    Row(
                      children: [
                        CustomTextWidget(
                          Helpers.translatingWord("poster_dim".tr()),
                          textStyle: AppStyle.mainTextSecondaryStyle.copyWith(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: AppColor.blackModern700Light),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: CustomTextFieldWidget(
                            label: "poster_length".tr(),
                            keyboardType: TextInputType.number,
                            isDigitsOnly: true,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r"^(?!0$)\d+$")),
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            initialValue:
                                length != null ? length.toString() : null,
                            suffixIcon: Text("poster_cm".tr()),
                            onChanged: (String? value) {
                              setState(() {
                                length = double.tryParse(value ?? "");
                              });
                              _area.text =
                                  ((length ?? 0) * (width ?? 0)).toString();
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: CustomTextFieldWidget(
                            label: "poster_width".tr(),
                            keyboardType: TextInputType.number,
                            isDigitsOnly: true,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r"^(?!0$)\d+$")),
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            initialValue:
                                width != null ? width.toString() : null,
                            suffixIcon: Text("poster_cm".tr()),
                            onChanged: (String? value) {
                              setState(() {
                                width = double.tryParse(value ?? "");
                              });
                              _area.text =
                                  ((length ?? 0) * (width ?? 0)).toString();
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: CustomTextFieldWidget(
                            label: "poster_area".tr(),
                            suffixIcon: Text("poster_cm2".tr()),
                            enabled: false,
                            controller: _area,
                          ),
                        ),
                      ],
                    ),
                    if (posterType?.id == 1951) ...[
                      const SizedBox(
                        height: 32,
                      ),
                      CustomTextFieldWidget(
                        label: "posters_percentage_discount".tr(),
                        keyboardType: TextInputType.number,
                        initialValue: discountPercentage != null
                            ? discountPercentage.toString()
                            : null,
                        onChanged: (String? value) {
                          setState(() {
                            discountPercentage = int.tryParse(value ?? "");
                          });
                        },
                      )
                    ],
                    const SizedBox(
                      height: 32,
                    ),
                    if (attachments == null)
                      ReloadWidget(
                        onTab: () async {
                          attachments = await context
                                  .read<PostersLicenseBloc>()
                                  .getAttachments(posterType!.id!) ??
                              [];
                          setState(() {});
                        },
                      ),
                    AttachmentListWidget(
                      attachments: attachments ?? [],
                      deleteFile: (int index) {
                        /*   context
                                        .read<RenewCommercialLicenseBloc>()
                                        .deleteFile(index);*/

                        attachments?[index].base64 = null;
                        attachments?[index].fileName = null;
                        attachments?[index].filePath = null;

                        setState(() {});
                      },
                      saveFile: (int index, String filePath, String fileName,
                          String base64) async {
                        PermitAttachmentItem? item = attachments?[index]
                            .copyWith(
                                base64: base64,
                                fileName: fileName,
                                posterTypeId: posterType?.id,
                                filePath: filePath);

                        PostersUploadResponse? uploadResponse = await context
                            .read<PostersLicenseBloc>()
                            .uploadAttachment(item!);
                        if (uploadResponse != null) {
                          attachments?[index] =
                              item.copyWith(key: uploadResponse?.key);

                          setState(() {});
                        }
                      },
                    ),
                    /* if (attachments?.isNotEmpty ?? false)
                      ...(attachments ?? []).map((e) {
                        return AttachmentListWidget(
                          attachments: attachments ?? [],
                          deleteFile: (int index) {
                            /*   context
                                        .read<RenewCommercialLicenseBloc>()
                                        .deleteFile(index);*/
                          },
                          saveFile: (int index, String filePath, String fileName,
                              String base64) {
                            /* context.read<RenewCommercialLicenseBloc>().saveFile(
                                        index: index,
                                        fileName: fileName,
                                        fileBase64: base64,
                                        filePath: filePath);*/
                          },
                        );
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: ElevatedButtonWidget.primaryCustomBorder(
                              onPressed: () {}, text: e.name ?? ""),
                        );
                      }).toList(),*/
                    const SizedBox(
                      height: 32,
                    ),
                    ElevatedButtonWidget.custom(
                        text: widget.item == null
                            ? "add".tr()
                            : "saveButton".tr(),
                        isDisabled: !isFormValid(),
                        onPressed: () {
                          PosterItem item = PosterItem(
                              length: length,
                              width: width,
                              name: posterName,
                              discountPercentage: discountPercentage,
                              attachedDocuments: attachments,
                              posterType: posterType);

                          widget.onAdd(item);
                          Navigator.pop(context, item);
                        })
                  ],
                ),
              ),
              if (state.status.isSubmissionLoading)
                const CustomCircularLoadingWidget(),
            ],
          ),
        ),
      );
    });
  }

  bool isFormValid() {
    bool isValid = true;
    if (posterType == null ||
        (posterName?.isEmpty ?? true) ||
        length == null ||
        width == null) {
      isValid = false;
    }

    attachments?.forEach((element) {
      if (element.mandatory == true && element.filePath == null)
        isValid = false;
    });

    if (posterType?.id == 1951 && discountPercentage == null) isValid = false;

    return isValid;
  }
}

class AttachmentListWidget extends StatelessWidget {
  final List<PermitAttachmentItem>? attachments;
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
        itemCount: attachments?.length ?? 0,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (ctx, index) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
            child: AttachmentWidget(
              fileIndex: index,
              title: attachments?[index].name ?? "",
              isRequired: attachments?[index].mandatory == true,
              path: attachments?[index].filePath,
              fileName: attachments?[index].fileName,
              onPress: () {
                if (attachments?[index].filePath != null &&
                    !attachments![index].filePath!.startsWith("http"))
                  CommonFunctions.openFile(File(attachments![index].filePath!));
                else if (attachments?[index].filePath != null &&
                    attachments![index].filePath!.startsWith("http")) {
                  CommonFunctions.showApigeeFile(
                      attachments?[index].filePath ?? "", "");
                }
              },
              hint: attachments?[index].allowedFilesExtension ?? "",
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
/*
  void showFile(String fileUrl, String fileName) async {
    try {
      if (fileName.toLowerCase().contains(".png") ||
          fileName.toLowerCase().contains(".jpeg") ||
          fileName.toLowerCase().contains(".jpg")) {
     
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
*/
}
