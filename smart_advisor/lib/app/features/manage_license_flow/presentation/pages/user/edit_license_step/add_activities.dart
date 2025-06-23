import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_advisor/app/core/utils/constants/app_colors.dart';
import 'package:smart_advisor/app/core/utils/constants/app_style.dart';
import 'package:smart_advisor/app/features/manage_license_flow/presentation/blocs/main_flow_bloc/main_flow_bloc.dart';
import 'package:smart_advisor/app/features/shared_features/widgets/check_box_item.dart';

import '../../../../../select_activity/domain/entities/addetional_activites_response.dart';

class AddActivities extends StatefulWidget {
  static String title = "AddActivities";

  const AddActivities({super.key});

  @override
  State<AddActivities> createState() => _AddActivitiesState();
}

class _AddActivitiesState extends State<AddActivities> {
// List to track selected states of the checkboxes
  List<AddetionalActivityItem> selectedValues = [];

  @override
  void initState() {
    super.initState();

    context.read<ManageMainFlowBloc>().add(const ChangeValueEvent(
          currentPagesNumber: 4,
          editSelection: 1,
          isLastEditPage: true,
        ));
  }

  // Function to handle checkbox selection
  void onCheckboxSelected(AddetionalActivityItem item) {
    setState(() {
      selectedValues.add(item);
    });
  }

  String query = "";
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ManageMainFlowBloc, ManageMainFlowState>(
        builder: (context, state) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: const Color(0xFFF4F6FB),
          body: SingleChildScrollView(
            child: Column(
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
                              "ما الانشطة التي تريد اضافتها لرخصتك ؟",
                              textAlign: TextAlign.center,
                              style: AppStyle.somarSemiBold
                                  .copyWith(color: AppColor.textPrimaryColor),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "اختر الانشطة المناسبه من القائمة",
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
                                itemCount:
                                    state.addetainalActivites?.length ?? 0,
                                itemBuilder: (context, index) {
                                  return CheckBoxItem(
                                    color: AppColor.white,
                                    currentValue: selectedValues.contains(
                                        state.addetainalActivites![index]),
                                    title: state.addetainalActivites?[index]
                                            .activityName ??
                                        "",
                                    onSelect: (bool? newValue) {
                                      if (newValue != null) {
                                        onCheckboxSelected(
                                            state.addetainalActivites![index]);
                                        setState(() {});
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
                    if ((state.addetainalActivites?.isEmpty ?? true)) ...[
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
        ),
      );
    });
  }
}
