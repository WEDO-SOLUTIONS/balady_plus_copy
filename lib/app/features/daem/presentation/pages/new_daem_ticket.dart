import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/enums/bloc_status.dart';
import '../../../_shared_feature_/presentation/widgets/custom_cupertino_drop_down_widget.dart';
import '../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_field_widget.dart';
import '../../data/models/daem_item.dart';
import '../core/bloc/new_ticket_bloc/new_daem_ticket_bloc.dart';
import '../widgets/daem_attachment_info_section.dart';
import '../widgets/previous_next_buttons.dart';

class NewDaemTicket extends StatefulWidget {
  NewDaemTicket({Key? key}) : super(key: key);

  @override
  _NewDaemTicket createState() => _NewDaemTicket();
}

class _NewDaemTicket extends State<NewDaemTicket> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.only(bottom: 85, right: 30, left: 30),
              child: OrderInfoSection(),
            ),
          ),
        ),
        PreviousNextButtons()
      ],
    );
  }
}

class OrderInfoSection extends StatefulWidget {
  OrderInfoSection({Key? key}) : super(key: key);

  @override
  State<OrderInfoSection> createState() => _OrderInfoSectionState();
}

class _OrderInfoSectionState extends State<OrderInfoSection> {
  final FocusNode _specialtyDescFocusNode = FocusNode();

  final FocusNode _descFocusNode = FocusNode();

  final TextEditingController _specialtyDescController =
      TextEditingController();

  final TextEditingController _descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    NewDaemTicketBloc model = BlocProvider.of<NewDaemTicketBloc>(context);

    return BlocBuilder<NewDaemTicketBloc, NewDaemTicketState>(
      builder: (context, state) {
        return Column(
          children: <Widget>[
            // Muncupility And SubMunciplity
            /*CustomSectionHeaderWithImg(
              title: Helpers.translatingWord('daem_municipality_subMunicipality'),
              img: "locationList@3x.png",
            ),*/

            // Muncipality
            const CustomVerticalSpace(height: 20),

            TapWidgetForLongDialog(
              onChangeType: (DaemItem? item) {
                if (item != null) {
                  model.add(GetDaemSubMunicipalitiesEvent(
                    municipality: item,
                  ));
                }
              },
              items: model.municipalities ?? [],
              value: model.state.municipality,
              label: ("daem_municiplaity").tr(),
              hint: ("daem_municiplaity").tr(),
            ),

            // Sub Muncipality
            if (model.showSubMunicipalityList())
              TapWidgetForLongDialog(
                key: UniqueKey(),
                onChangeType: (DaemItem? item) {
                  if (item != null) {
                    model.add(SetSubMunicipalityEvent(subMunicipality: item));
                  }
                },
                items: model.subMunicipalities ?? [],
                value: model.state.subMunicipality,
                label: ("daem_sub_municiplaity").tr(),
                hint: ("daem_sub_municiplaity").tr(),
              ),

            //MM
            /* CustomSectionHeaderWithImg(
              title: Helpers.translatingWord('daem_ticket_info'),
              img: "contractType@3x.png",
            ),*/

            //  Sub category widget
            TapWidgetForLongDialog(
              onChangeType: (DaemItem? item) {
                if (item != null) {
                  model.add(GetDaemAreaListEvent(
                      category: model.state.category!, subCategory: item));
                }
              },
              items: model.subCategoryTypeList,
              value: model.state.subCategory,
              label: ("daem_main_classification").tr(),
              hint: ("daem_main_classification").tr(),
            ),

            //  area category widget
            if (model.showAreaList())
              TapWidgetForLongDialog(
                key: UniqueKey(),
                onChangeType: (DaemItem? item) {
                  if (item != null) {
                    model.add(GetDaemIssueTypeEvent(
                      category: model.state.category!,
                      subCategory: model.state.subCategory!,
                      area: item,
                    ));
                  }
                },
                items: model.areaList ?? [],
                value: model.state.area,
                label: ("daem_sub_classification").tr(),
                hint: ("daem_sub_classification").tr(),
              ),

            //  issuetype category widget
            if (model.showIssueTypeList())
              TapWidgetForLongDialog(
                key: UniqueKey(),
                onChangeType: (DaemItem? item) {
                  if (item != null) {
                    model.add(SetIssueTypeEvent(
                      issueType: item,
                    ));
                  }
                },
                items: model.issueypeList ?? [],
                value: model.state.issueType,
                label: ("daem_spl_classification").tr(),
                hint: ("daem_spl_classification").tr(),
              ),

            //  incident Desc ,
            CustomTextFieldWidget(
              controller: _descController,
              focusNode: _descFocusNode,
              label: ("daem_ticket_desc").tr(),
              hintText: ("daem_ticket_desc").tr(),
              obsecureText: false,
              maxLines: 4,
              fillColor: Colors.transparent,
              keyboardType: TextInputType.multiline,
              onValidate: (text) {
                if (!CommonFunctions.doesContainsLettrs(text.toString())) {
                  return ("description_limit").tr();
                }
                return null;
              },
              onChanged: (text) {
                model.add(SetDescriptionEvent(
                  text: text,
                ));
              },
            ),
            //MM
            /* CustomSectionHeaderWithImg(
              title: Helpers.translatingWord('optional_attachment'),
              img: "photo@3x.png",
            ),*/

            CustomVerticalSpace(height: 20),
            DaemAttachmentInfoSection(
                uploadedFiles: model.state.uploadedFiles,
                deleteFile: (int index) {
                  model.add(DeleteAttachmentFileEvent(index));
                },
                saveFile: (int index, String filePath, String fileName,
                    String base64) {
                  model.add(AddAttachmentFileEvent(
                      index: index,
                      base64: base64,
                      fileName: fileName,
                      filePath: filePath));
                }),
          ],
        );
      },
    );
  }
}
