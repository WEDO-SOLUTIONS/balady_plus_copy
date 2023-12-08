import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/core/utils/enums/enums.dart';
import 'package:balady_plus/etmam_app/core/utils/enums/app_font_weight.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:timelines/timelines.dart';

import '../../../../../../etmam_app/features/_shared_feature_/shared/presentation/widgets/header_with_view_all_widget.dart';
import '../../../../../core/services/local/navigation_services.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/constants.dart';
import '../../../../../core/utils/enums/bloc_status.dart';
import '../../../../_shared_feature_/presentation/widgets/draw_line_widget.dart';
import '../../../../home_page/presentation/widgets/home_tag.dart';
import '../../../../vd/presentation/widgets/vd_header_desc_widget.dart';
import '../../data/models/request_details_response.dart';
import '../details_bloc/crm_details_bloc.dart';
import '../reply_retrieve_vehicles_bloc/retrieve_vehicles_bloc.dart';
import 'reply_retrive_car_dialog/note_field_section.dart';
import 'reply_retrive_car_dialog/reply_attachment_section.dart';
import 'reply_retrive_car_dialog/reply_submit_btn.dart';

class RepliesStatusCard extends StatefulWidget {
  final String? status;
  final List<String> auditInformation;
  final String pzInsKey;
  final String? visibleFlag;
  final CrmDetailsBloc bloc;

  const RepliesStatusCard(
      {Key? key,
      required this.auditInformation,
      required this.pzInsKey,
      this.status,
      this.visibleFlag,
      required this.bloc})
      : super(key: key);

  @override
  _RepliesStatusCardState createState() => _RepliesStatusCardState();
}

class _RepliesStatusCardState extends State<RepliesStatusCard> {
  bool showInfo = true;
  bool showImages = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          boxShadow: [
            BoxShadow(
                color: Color(0x26000000),
                offset: Offset(0, 2),
                blurRadius: 5,
                spreadRadius: 0)
          ],
          color: Colors.white),
      // padding: const EdgeInsets.all(18),
      padding: const EdgeInsets.only(top: 18, right: 18, left: 18),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomTextWidget(
                ('vhr_replies').tr(),
                fontColor: AppColor.blackModern900Light,
                fontWeight: AppFontWeight.bold,
                fontSize: 20,
              ),
              /*if (widget.status != null)
                HomeTag(
                  title: widget.status!,
                  backgroundColor: AppColor.secondary100Light,
                ),*/
            ],
          ),
          CustomVerticalSpace(height: 12),

          ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: !showInfo ? 1 : widget.auditInformation.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (ctx, index) {
              String desc = widget.auditInformation[index];

              return TimelineTile(
                nodeAlign: TimelineNodeAlign.start,
                contents: Container(
                  margin: const EdgeInsetsDirectional.only(
                      start: 16,
                      top: /*desc != null &&
                      widget.auditInformation.auditList[index]
                          .getDesc(widget.municipalityName)
                          .isNotEmpty
                      ?*/
                          20 /*: 5*/),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextWidget(
                            desc,
                            fontColor: Color(0xFF292929),
                            fontWeight: AppFontWeight.bold,
                            fontSize: 14,
                            textAlign: TextAlign.start,
                          ),
                          const CustomVerticalSpace(height: 10),
                          /*     desc != null &&
                                  widget.auditInformation.auditList[index]
                                      .getDesc(widget.municipalityName)
                                      .isNotEmpty
                              ?*/
                          if (widget.visibleFlag == "true")
                            CustomTextButtonWidget(
                                btnText: ("vhr_reply").tr(),
                                haveUnderline: true,
                                btnPressed: () =>
                                    _showReplyDialog(widget.pzInsKey)),
                          const CustomVerticalSpace(height: 20),
                        ],
                      ),
                    ],
                  ),
                ),
                node: TimelineNode(
                  indicator: const DotIndicator(
                    color: AppColor.primary900Light,
                    size: 10,
                  ),
                  startConnector: index == 0
                      ? const SolidLineConnector(
                          color: AppColor.primary50Light,
                        )
                      : index == 0
                          ? const SolidLineConnector(color: Colors.transparent)
                          : const SolidLineConnector(
                              color: AppColor.primary50Light,
                            ),
                  endConnector: index == widget.auditInformation.length - 1
                      ? const SolidLineConnector(color: Colors.transparent)
                      : const SolidLineConnector(
                          color: AppColor.primary50Light,
                        ),
                ),
              );
            },
          ),
          //    if (showMoreDetails()) showMoreButton(),
        ],
      ),
    );
  }

  _showReplyDialog(String pzInsKey) {
    showDialogWidget(NavigationService.navigatorKey.currentState!.context,
        dialogBody: ReplyRetriveCarDialog(
          pzInsKey: pzInsKey,
          onComplete: () {
            widget.bloc.add(GetCRMRequestEvent(id: pzInsKey));
          },
        ));
  }
}

class ReplyRetriveCarDialog extends StatefulWidget {
  final String pzInsKey;
  final Function onComplete;
  const ReplyRetriveCarDialog(
      {super.key, required this.pzInsKey, required this.onComplete});

  @override
  State<ReplyRetriveCarDialog> createState() => _ReplyRetriveCarDialogState();
}

class _ReplyRetriveCarDialogState extends State<ReplyRetriveCarDialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReplyRetrieveVehiclesBloc(pzInsKey: widget.pzInsKey),
      child:
          BlocConsumer<ReplyRetrieveVehiclesBloc, ReplyRetrieveVehiclesState>(
              listener: (context, state) {
        if (state.status == BlocStatus.failure) {
          CommonFunctions.showError(state.errorMessage ?? "");
        }
        if (state.status == BlocStatus.success1) {
          NavigationService.navigatorKey.currentState?.pop();

          widget.onComplete();
        }
      }, builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.only(top: 24, left: 16, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      VdHeaderDesc(
                        header: ("vhr_add_reply").tr(),
                      ),
                      NotesFieldsSection(initialDesc: state.notes),
                      ReplyAttachmentSection(),
                      CustomVerticalSpace(height: 100),
                      ReplySubmitBtn(),
                      if (state.status == BlocStatus.loading)
                        CustomLoadingWidget()
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
