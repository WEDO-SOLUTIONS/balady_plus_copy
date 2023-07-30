import 'package:balady_plus/app/core/utils/enums/enums.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/common_functions.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../../../core/utils/enums/app_font_weights.dart';
import '../../../../_shared_feature_/presentation/under_testing/custom_expansion_panel_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/details_header.dart';
import '../../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../../home_page/presentation/widgets/home_tag.dart';
import '../../../../objectable_transactions/presentation/widgets/summery_widgets/field_data.dart';
import '../../domain/entities/request_details_page_params.dart';
import '../details_bloc/crm_details_bloc.dart';

class InqDetailsPage extends StatelessWidget {
  final RequestDetailsPageParams params;
  const InqDetailsPage({super.key, required this.params});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CrmDetailsBloc(crmRequestType: RequestsType.INC, pageParams: params),
      child: BlocConsumer<CrmDetailsBloc, CrmDetailsState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return Scaffold(
              backgroundColor: AppColor.white2,
              appBar: DetailsHeader(
                title: ("appointment").tr(),
                onPrint: null,
                procedures: () async {
                  /*   await BottomSheetDialog.showDraggableSheet(context,
                          isFullHeight: false,
                          height: 250,
                          child: BottomSheetWithActions(
                            title: "الاجراءات".tr(),
                            body: Column(children: [
                              if (appointmentItemInfoLocal?.confirmable ?? false)
                                GestureDetector(
                                  onTap: () {
                                    model.confirmAppointment();
                                  },
                                  child: FieldData(
                                    title: "تأكيد الموعد",
                                  ),
                                ),
                              CustomVerticalSpace(height: 16),
                              if (widget.isCancelable ??
                                  appointmentItemInfoLocal!.cancelable ??
                                  false)
                                GestureDetector(
                                    onTap: () async {
                                      await BottomSheetDialog.showDraggableSheet(
                                        context,
                                        child: const ConfirmCancelAppointmentDialog(),
                                        isFullHeight: false,
                                      );
                                    },
                                    child: FieldData(title: "الغاء الموعد"))
                            ]),
                          ));*/
                },
              ),
              body: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                      child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(
                                IconPath.calendarIcon,
                                width: 24,
                                height: 24,
                              ),
                              CustomHorizontalSpace(width: 8),
                              CustomTextWidget(
                                CommonFunctions.getFormattedDate(""),
                                fontColor: AppColor.blackModern500Light,
                                fontSize: 12,
                                fontWeight: AppFontWeight.bold,
                              )
                            ],
                          ),
                          HomeTag(
                            title: "",
                            backgroundColor: AppColor.secondary100Light,
                          ),
                        ],
                      ),
                      const CustomVerticalSpace(height: 16),
                      CustomExpansionPanelWidget(
                          title: ("ملخص البلاغ").tr(),
                          leading: SvgPicture.asset(IconPath.vdSummuryDesc),
                          children: [
                            FieldData(
                              title: ("العنوان").tr(),
                              subTitle: state.details?.locationInfo?.address,
                            ),
                            FieldData(
                              title: ("التصنيف التخصصي").tr(),
                              subTitle: "",
                            ),
                            FieldData(
                              title: ("الوصف").tr(),
                              subTitle: state.details?.incidentInformation
                                  ?.issueDescription,
                            ),
                          ]),
                      CustomVerticalSpace(height: 16),
                      CustomExpansionPanelWidget(
                          title: ("المرفقات").tr(),
                          leading: SvgPicture.asset(IconPath.vdSummuryDesc),
                          children: []),
                    ],
                  ))));
        },
      ),
    );
  }
}
