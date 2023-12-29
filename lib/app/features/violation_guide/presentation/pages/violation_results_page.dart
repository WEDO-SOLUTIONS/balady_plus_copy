import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/features/violation_guide/presentation/bloc/violation_bloc.dart';
import 'package:balady_plus/app/features/violation_guide/presentation/widgets/violation_results_widgets/violation_approved_widget.dart';
import 'package:balady_plus/app/features/violation_guide/presentation/widgets/violation_results_widgets/violation_number_widget.dart';
import 'package:balady_plus/app/features/violation_guide/presentation/widgets/violation_results_widgets/violation_result_title_section.dart';
import 'package:balady_plus/app/features/violation_guide/presentation/widgets/violation_results_widgets/violation_results_selection_widget.dart';
import 'package:balady_plus/app/features/violation_guide/presentation/widgets/violation_results_widgets/violations_not_approved_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/common_functions.dart';
import '../../../../core/utils/constants/ux_cam_events.dart';
import '../../../../core/utils/enums/bloc_status.dart';
import '../../../_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../data/models/regulation_clause_response.dart';
import '../bloc/violation_state.dart';

class ViolationResultsPage extends StatefulWidget {
  const ViolationResultsPage({super.key});

  @override
  State<ViolationResultsPage> createState() => _ViolationResultsPageState();
}

class _ViolationResultsPageState extends State<ViolationResultsPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CommonFunctions.sendUXCamEvent(UXCamEvents.finishServiceViolationsGuide);

    CommonFunctions.sendUXCamEvent(UXCamEvents.finishServiceViolationsGuide);
  }

  bool crticalSelected = true;
  @override
  Widget build(BuildContext context) {
    ViolationBloc bloc =
        ModalRoute.of(context)!.settings.arguments as ViolationBloc;

    return BlocProvider.value(
      value: bloc,
      child: BlocConsumer<ViolationBloc, ViolationState>(
          listener: (context, state) {
        if (state.ViolatorsStatus == BlocStatus.failure ||
            state.classificationStatus == BlocStatus.failure ||
            state.status == BlocStatus.failure)
          CommonFunctions.showError(state.errorMessage ?? "");
      }, builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColor.scaffoldBackground,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.close,
                ),
                color: Colors.black,
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
            backgroundColor: AppColor.scaffoldBackground,
            title: Text(
              'result-1'.tr(),
              style: AppStyle.violationCreateAppBarTitle,
            ),
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ViolationNumberResultWidget(),
                        SizedBox(
                          height: 16,
                        ),
                        //  ViolationResultsSelectionListWidget(),

                        Container(
                          height: 50,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      crticalSelected = true;
                                    });
                                  },
                                  child: Container(
                                    height: 42,
                                    alignment: Alignment.center,
                                    decoration: ShapeDecoration(
                                      color: crticalSelected
                                          ? AppColor.primary900Light
                                          : AppColor.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      shadows: [
                                        BoxShadow(
                                          color: Color(0x3F9EA5B7),
                                          blurRadius: 20,
                                          offset: Offset(0, 4),
                                          spreadRadius: 0,
                                        )
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        CustomTextWidget(
                                          "approved_violation_title".tr(),
                                          fontColor: !crticalSelected
                                              ? AppColor.primary900Light
                                              : AppColor.white,
                                          fontSize: 12,
                                          fontWeight: AppFontWeight.bold,
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        CustomTextWidget(
                                          "(${state.critical().length})",
                                          fontColor: !crticalSelected
                                              ? AppColor.primary900Light
                                              : AppColor.white,
                                          fontSize: 12,
                                          fontWeight: AppFontWeight.bold,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      crticalSelected = false;
                                    });
                                  },
                                  child: Container(
                                    height: 42,
                                    alignment: Alignment.center,
                                    decoration: ShapeDecoration(
                                      color: !crticalSelected
                                          ? AppColor.primary900Light
                                          : AppColor.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      shadows: [
                                        BoxShadow(
                                          color: Color(0x3F9EA5B7),
                                          blurRadius: 20,
                                          offset: Offset(0, 4),
                                          spreadRadius: 0,
                                        )
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        CustomTextWidget(
                                          "violation_title_2".tr(),
                                          fontColor: crticalSelected
                                              ? AppColor.primary900Light
                                              : AppColor.white,
                                          fontSize: 12,
                                          fontWeight: AppFontWeight.bold,
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        CustomTextWidget(
                                          "(${state.notCritical().length})",
                                          fontColor: crticalSelected
                                              ? AppColor.primary900Light
                                              : AppColor.white,
                                          fontSize: 12,
                                          fontWeight: AppFontWeight.bold,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        //    ViolationResultsSectionTitle(),
                        if (crticalSelected) ViolationApprovedWidget(),
                        if (!crticalSelected) ViolationsNotApprovedWidget(),
                      ]),
                ),
              ),
              if (state.ViolatorsStatus == BlocStatus.loading ||
                  state.establishmentStatus == BlocStatus.loading ||
                  state.status == BlocStatus.loading)
                CustomCircularLoadingWidget()
            ],
          ),
        );
      }),
    );
  }
}
