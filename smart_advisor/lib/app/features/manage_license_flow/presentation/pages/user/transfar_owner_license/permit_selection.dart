import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_advisor/app/core/utils/constants/app_colors.dart';
import 'package:smart_advisor/app/core/utils/constants/app_style.dart';
import 'package:smart_advisor/app/features/manage_license_flow/presentation/blocs/main_flow_bloc/main_flow_bloc.dart';
import 'package:smart_advisor/app/features/shared_features/widgets/check_box_item.dart';

class PermitSelection extends StatefulWidget {
  static String title = "PermitSelection";

  const PermitSelection({super.key});

  @override
  State<PermitSelection> createState() => _PermitSelectionState();
}

class _PermitSelectionState extends State<PermitSelection> {
  /*List addetionalActivitesResponse = [
    {'id': 0, "activityName": 'تصريح 24 ساعة'},
    {'id': 1, "activityName": 'تصريح فعالية'},
    {'id': 2, "activityName": 'تصريح جهاز صراف آلي'}
  ];*/
  String query = "";

// List to track selected states of the checkboxes
  List<int> selectedValues = [];

  @override
  void initState() {
    super.initState();
    context.read<ManageMainFlowBloc>().add(const ChangeValueEvent(
          isLastTransfarPage: true,
        ));
  }

  // Function to handle checkbox selection
  void onCheckboxSelected(int id) {
    setState(() {
      if (selectedValues.contains(id))
        selectedValues.remove(id);
      else
        selectedValues.add(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ManageMainFlowBloc, ManageMainFlowState>(
        builder: (context, state) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: const Color(0xFFF4F6FB),
          body: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(top: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "ما التصاريح التي تريد نقلها مع الرخصة؟",
                            textAlign: TextAlign.center,
                            style: AppStyle.somarSemiBold
                                .copyWith(color: AppColor.textPrimaryColor),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "تعرض القائمة التصاريح المدرجة تحت الرخصة",
                            textAlign: TextAlign.center,
                            style: AppStyle.textRegularStyle
                                .copyWith(color: AppColor.textSecondaryColor),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          MediaQuery.removePadding(
                            removeTop: true,
                            context: context,
                            child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: state.selectedLicenseDetails
                                  ?.licenseAllowedPermitsInfo?.length,
                              itemBuilder: (context, index) {
                                return CheckBoxItem(
                                  color: AppColor.white,
                                  currentValue: selectedValues.contains(state
                                      .selectedLicenseDetails
                                      ?.licenseAllowedPermitsInfo?[index]
                                      .id),
                                  title: state
                                          .selectedLicenseDetails
                                          ?.licenseAllowedPermitsInfo?[index]
                                          .name ??
                                      "",
                                  onSelect: (bool? newValue) {
                                    if (newValue != null) {
                                      onCheckboxSelected(
                                        state
                                                .selectedLicenseDetails
                                                ?.licenseAllowedPermitsInfo?[
                                                    index]
                                                .id ??
                                            0,
                                      ); // Update state on selection
                                    }
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if ((state.selectedLicenseDetails?.licenseAllowedPermitsInfo
                          ?.isEmpty ??
                      true)) ...[
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            "packages/smart_advisor/smart_advisor_assets/images/searchimg.png",
                            height: 122,
                            width: 150,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "لا يوجد",
                            textAlign: TextAlign.center,
                            style: AppStyle.textRegularRomanStyle
                                .copyWith(color: const Color(0xFF566069)),
                          ),
                        ],
                      ),
                    )
                  ],
                ],
              )
            ],
          ),
        ),
      );
    });
  }
}
