import 'dart:math';

import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/data/entities/file_data_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../core/base/base_view.dart';
import '../../../../../../core/base/base_view_model.dart';
import '../../../../../../core/services/local/navigation_services.dart';
import '../../../../../_shared_feature_/data/entities/drop_down_item.dart';
import '../../../../../_shared_feature_/presentation/dialogs/incident_type_with_search_dialog.dart';
import '../../../../../_shared_feature_/presentation/widgets/custom_cupertino_drop_down_widget.dart';
import '../../../../../_shared_feature_/presentation/widgets/custom_popups_widgets.dart';
import '../../../../../_shared_feature_/presentation/widgets/texts/custom_text_field_widget.dart';
import '../../../../customer_voice_exports.dart'
    show AttachmentList, NewMSRDetailsViewModel;
import '../widgets/previous_next_buttons.dart';

class NewRequestDetailsScreen extends StatefulWidget {
  const NewRequestDetailsScreen({Key? key}) : super(key: key);

  @override
  _NewRequestDetailsScreen createState() => _NewRequestDetailsScreen();
}

class _NewRequestDetailsScreen extends State<NewRequestDetailsScreen> {
  final model = locator<NewMSRDetailsViewModel>();

  @override
  void initState() {
    super.initState();
    model.validateForm();
    model.file = null;
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<NewMSRDetailsViewModel>(
        onModelReady: (model) {},
        builder: (context, model, child) {
          return Column(
            children: [
              // MSR body
              Expanded(child: MSRBody()),
              // submit button

              PreviousNextButtons()
            ],
          );
        });
  }
}

class MSRBody extends StatefulWidget {
  final bool withLocationSection;

  const MSRBody({Key? key, this.withLocationSection = false}) : super(key: key);

  @override
  _MSRBody createState() => _MSRBody();
}

class _MSRBody extends State<MSRBody> {
  final model = locator<NewMSRDetailsViewModel>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.only(bottom: 85, top: 32),
        margin: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Request Type Section
              RequestTypeSection(
                onChangeType: (DropDownItem? item) {
                  if (item != null) {
                    model.getSPLDetails(item);
                    model.validateForm();
                  }
                },
                items: model.splTypeList,
                value: model.splType,
              ),
              // Request Info Section
              RequestInfoSection(),

              // add Action to upload attachment hear

              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Text(
                    "${'attachment'.tr()} ( ${'Optional'.tr()} )",
                    style: const TextStyle(
                      color: AppColor.blackModern700Light,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  model.file == null
                      ? InkWell(
                          onTap: () async {
                            FileDataItem? file = await CommonFunctions.pickFile(
                              context,
                            );
                            if (file != null) {
                              if ("jpg,jpeg,pdf,png".contains(file.fileName.split(".").last)) {
                                // var i = (log(file.bytes!.length) / log(1000)).floor();
                                 double sizeInMB = file.bytes!.length / pow(1000, 1);
                                if (sizeInMB <= 5000) {
                                  model.setFile(file);
                                } else {
                                  CommonFunctions.showError('${'attachment_message_typ'.tr()} jpg,jpeg,pdf,png ${'attachment_message_size'.tr()} 5MB');
                                }
                              } else {
                                CommonFunctions.showError("${'attachment_message_typ'.tr()} jpg,jpeg,pdf,png");
                              }
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.only(top: 6),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(16)),
                              border: Border.all(
                                color: AppColor.primary800Light,
                              ),
                              color: Colors.transparent,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'attachFileButton'.tr(),
                                  style: const TextStyle(
                                    color: AppColor.primary800Light,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Row(
                          children: [
                            Flexible(
                              fit: FlexFit.tight,
                              child: Text(
                                model.file!.fileName,
                                style: const TextStyle(
                                  color: AppColor.primary900Light,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 3,
                              ),
                            ),
                            const SizedBox(width: 6),
                            IconButton(
                              onPressed: () {
                                model.setFile(null);
                              },
                              color: AppColor.error,
                              icon: const Icon(Icons.close),
                            ),
                          ],
                        ),
                  const SizedBox(height: 6),
                  Text(
                    '${'attachment_message_typ'.tr()} jpg,jpeg,pdf,png ${'attachment_message_size'.tr()} 5MB',
                    style: const TextStyle(
                      color: AppColor.blackModern700Light,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 3,
                  ),
                ],
              ),

              // displae attachment section from API
              if (model.attachments.isNotEmpty)
                AttachmentList(
                  attachments: model.attachments,
                  deleteFile: (int index) {
                    model.attachments[index].fileName = null;
                    model.attachments[index].filePath = null;
                    model.attachments[index].base64 = null;
                    model.validateForm();
                    setState(() {});
                  },
                  saveFile: (int index, String filePath, String fileName,
                      String base64) {
                    model.attachments[index].fileName = fileName;
                    model.attachments[index].filePath = filePath;
                    model.attachments[index].base64 = base64;
                    model.validateForm();
                    setState(() {});
                    // model.notifyListeners();
                  },
                )
            ]),
      ),
    );
  }
}

class RequestTypeSection extends StatefulWidget {
  DropDownItem? value;
  Function(DropDownItem? item) onChangeType;
  List<DropDownItem> items;

  RequestTypeSection(
      {required this.onChangeType, this.value, required this.items});

  @override
  State<RequestTypeSection> createState() => _RequestTypeSectionState();
}

class _RequestTypeSectionState extends State<RequestTypeSection> {
  final model = locator<NewMSRDetailsViewModel>();
  final FocusNode _specialtyDescFocusNode = FocusNode();
  final TextEditingController _specialtyDescController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CustomHeaderAndDescOnTapWidget(
          label: ("lbl_specialty_classification_hint1").tr(),
          hintText: ("lbl_specialty_classification_hint2").tr(),
          textValue: widget.value?.name,
          onTap: () async {
            //MM model.hideKeyboard();
            await CustomPopUpsWidgets.showBottomSheet(
              NavigationService.navigatorKey.currentContext!,
              child: IncidentTypeWithSearchDialog(
                title: ('lbl_specialty_classification_hint2').tr(),
                searchHint: ('search_for_specialty_classification').tr(),
                onSelect: (DropDownItem item) => widget.onChangeType(item),
                items: widget.items,
                selectedItem: widget.value,
              ),
            );
          },
        ),
        if (model.showSPLDescription())
          CustomTextFieldWidget(
            controller: _specialtyDescController,
            focusNode: _specialtyDescFocusNode,
            label: ("spl_description").tr(),
            hintText: ("spl_description_hint").tr(),
            obsecureText: false,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            onSubmitted: (_) {
              // FocusScope.of(context).requestFocus(_incidentDescFocusNode);
            },
            onChanged: (String text) {
              model.splDescription = text;
              model.validateForm();
            },
            onValidate: (text) {
              if (text.toString().isEmpty) {
                return ('text_field_error').tr();
              }
              return null;
            },
          ),
      ],
    );
  }
}

class RequestInfoSection extends StatefulWidget {
  RequestInfoSection({Key? key}) : super(key: key);

  @override
  State<RequestInfoSection> createState() => _RequestInfoSectionState();
}

class _RequestInfoSectionState extends State<RequestInfoSection> {
  final TextEditingController _incidentDescController = TextEditingController();

  final FocusNode _incidentDescFocusNode = FocusNode();
  final model = locator<NewMSRDetailsViewModel>();

  @override
  void initState() {
    super.initState();
    _incidentDescController.text = model.desc ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        //  incident Desc ,
        CustomTextFieldWidget(
          controller: _incidentDescController,
          focusNode: _incidentDescFocusNode,
          label: ("description").tr(),
          hintText: ("order_desc_hint").tr(),
          fillColor: Colors.transparent,
          obsecureText: false,
          maxLines: 4,
          keyboardType: TextInputType.multiline,
          onChanged: (String text) {
            model.desc = text;
            model.validateForm();
          },
          onValidate: (text) {
            if (!CommonFunctions.doesContainsLettrs(text.toString())) {
              return ("description_limit").tr();
            }
            return null;
          },
        ),
      ],
    );
  }
}
