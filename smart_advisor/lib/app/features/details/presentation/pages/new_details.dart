//import 'package:casa_vertical_stepper/casa_vertical_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_advisor/app/core/utils/constants/app_colors.dart';
import 'package:smart_advisor/app/core/utils/utils_exports.dart';
import 'package:smart_advisor/app/features/details/presentation/bloc/details_bloc.dart';
import 'package:smart_advisor/app/features/details/presentation/widgets/newDetailswidget/compliance_license_card.dart';
import 'package:smart_advisor/app/features/details/presentation/widgets/newDetailswidget/doing_the_work.dart';
import 'package:smart_advisor/app/features/details/presentation/widgets/newDetailswidget/issue_license_card.dart';
import 'package:smart_advisor/app/features/details/presentation/widgets/newDetailswidget/general_info_widget.dart';
import 'package:smart_advisor/app/features/details/presentation/widgets/newDetailswidget/issue_your_license_card.dart';
import 'package:smart_advisor/app/features/details/presentation/widgets/newDetailswidget/location_license_card.dart';
import 'package:smart_advisor/app/features/select_activity/presentation/blocs/main_flow_bloc/main_flow_bloc.dart';
import 'package:smart_advisor/app/features/shared_features/new_app_bar.dart';

import '../../../../core/services/local/shared_prefs_manager.dart';
import '../../../select_activity/domain/entities/activity_details_page_params.dart';
import '../../../shared_features/widgets/custom_button.dart';

class NewDetails extends StatefulWidget {
  final ActivityDetailsPageParams args;

  const NewDetails({super.key, required this.args});

  @override
  State<NewDetails> createState() => _NewDetailsState();
}

class _NewDetailsState extends State<NewDetails> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sharedPrefs.saveRecentlyOpened(widget.args);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DetailsBloc(args: widget.args),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Stack(
          children: [
            Scaffold(
              backgroundColor: AppColor.backgroundColor,
              body: Stack(
                children: [
                  Column(
                    children: [
                      NewAppBar(title: 'رحلتك لفتح منشأتك الجديدة'),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Padding(padding: EdgeInsets.all(16)),
                              Generalinfowidget(),
                              const SizedBox(
                                height: 8,
                              ),
                              const IssueLicenseCard(number: 1),
                              const SizedBox(
                                height: 16,
                              ),
                              const LocationLicenseCard(
                                number: 2,
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              IssueYourLicenseCard(
                                number: 3,
                                args: widget.args,
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              const DoingTheWork(
                                number: 4,
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              const ComplianceLicenseCard(
                                number: 5,
                              ),
                              const SizedBox(
                                height: 100,
                              ),
                              // const LicenseStepWidget(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 100,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColor.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                              flex: 2,
                              child: CustomButton(
                                  isDisabled: false,
                                  onPress: () {
                                    if (widget.args.isFromHome == true) {
                                      Navigator.pop(context);
                                    } else {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    }
                                  },
                                  text: "العودة الى الرئيسية"))
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
/*
class LicenseStepWidget extends StatelessWidget {
  const LicenseStepWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CasaVerticalStepperView(
            completeColor: Color(0xffCEE3D7),
            upComingColor: Color(0xffCEE3D7),
            seperatorColor: Color(0xffCEE3D7),
            backgroundColor: Color(0xffCEE3D7),
            inProgressColor: Color(0xffCEE3D7),
            steps: [
              StepperStep(
                title: Container(
                  width: 1,
                ),
                leading: Row(
                  children: [
                    SizedBox(
                      width: 8,
                    ),
                    SvgPicture.asset(IconPath.stepIcon),
                  ],
                ),
                isExpanded: false,
                view: Container(
                  padding: EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: Color(0xff568F64).withOpacity(0.21)),
                    color: Color(0xff568F64).withOpacity(0.04),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(IconPath.stepCompleted),
                              SizedBox(
                                width: 4,
                              ),
                              Text(
                                "عرض الإشتراطات الخاصة بنشاطك",
                                style: AppStyle.somarSemiBold.copyWith(
                                    color: AppColor.textPrimaryColor,
                                    fontSize: 16),
                              ),
                            ],
                          ),
                          SvgPicture.asset(IconPath.stepCompleted)
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ]),
      ],
    );
    /* return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EasyStepper(
            activeStep: 2,
            lineStyle: LineStyle(
                activeLineColor: Color(0xffCEE3D7),
                defaultLineColor: Color(0xffCEE3D7),
                finishedLineColor: Color(0xffCEE3D7),
                lineLength: 20,
                lineThickness: 2,
                lineType: LineType.dotted,
                lineWidth: 10,
                lineSpace: 3,
                unreachedLineColor: Color(0xffCEE3D7)),
            finishedStepBorderColor: Color(0xffCEE3D7),
            activeStepTextColor: Color(0xffCEE3D7),
            finishedStepTextColor: Color(0xffCEE3D7),
            activeStepIconColor: Color(0xffCEE3D7),
            activeStepBorderColor: Color(0xffCEE3D7),
            finishedStepIconColor: Color(0xffCEE3D7),
            unreachedStepIconColor: Color(0xffCEE3D7),
            unreachedStepTextColor: Color(0xffCEE3D7),
            unreachedStepBorderColor: Color(0xffCEE3D7),
            activeStepBackgroundColor: Color(0xffCEE3D7),
            finishedStepBackgroundColor: Color(0xffCEE3D7),
            unreachedStepBackgroundColor: Color(0xffCEE3D7),
            internalPadding: 0,
            showLoadingAnimation: false,
            stepRadius: 8,
            direction: Axis.vertical,
            steppingEnabled: false,
            showStepBorder: false,
            titlesAreLargerThanSteps: false,
            alignment: Alignment.centerRight,
            activeStepBorderType: BorderType.normal,
            stepShape: StepShape.circle,
            defaultStepBorderType: BorderType.normal,
            padding: EdgeInsets.zero,
            steps: [
              EasyStep(
                lineText: "",
                icon: Icon(Icons.abc_outlined),
                customTitle: Row(
                  children: [
                    SizedBox(
                      width: 32,
                    ),
                    Container(
                      padding: EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Color(0xff568F64).withOpacity(0.21)),
                        color: Color(0xff568F64).withOpacity(0.04),
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset(IconPath.stepCompleted),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    "عرض الإشتراطات الخاصة بنشاطك",
                                    style: AppStyle.somarSemiBold.copyWith(
                                        color: AppColor.textPrimaryColor,
                                        fontSize: 16),
                                  ),
                                ],
                              ),
                              SvgPicture.asset(IconPath.stepCompleted)
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              EasyStep(
                icon: Icon(Icons.abc_outlined),
                customTitle: Row(
                  children: [
                    SizedBox(
                      width: 32,
                    ),
                    Container(
                      padding: EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Color(0xff568F64).withOpacity(0.21)),
                        color: Color(0xff568F64).withOpacity(0.04),
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset(IconPath.stepCompleted),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    "عرض الإشتراطات الخاصة بنشاطك",
                                    style: AppStyle.somarSemiBold.copyWith(
                                        color: AppColor.textPrimaryColor,
                                        fontSize: 16),
                                  ),
                                ],
                              ),
                              SvgPicture.asset(IconPath.stepCompleted)
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              EasyStep(
                icon: Icon(Icons.abc_outlined),
                customTitle: Row(
                  children: [
                    SizedBox(
                      width: 32,
                    ),
                    Container(
                      padding: EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Color(0xff568F64).withOpacity(0.21)),
                        color: Color(0xff568F64).withOpacity(0.04),
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset(IconPath.stepCompleted),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    "عرض الإشتراطات الخاصة بنشاطك",
                                    style: AppStyle.somarSemiBold.copyWith(
                                        color: AppColor.textPrimaryColor,
                                        fontSize: 16),
                                  ),
                                ],
                              ),
                              SvgPicture.asset(IconPath.stepCompleted)
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
            onStepReached: (index) {}),
      ],
    );
    */
  }
}
*/