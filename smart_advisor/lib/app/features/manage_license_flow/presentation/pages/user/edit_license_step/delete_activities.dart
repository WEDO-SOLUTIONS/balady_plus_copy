import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_advisor/app/core/utils/constants/app_colors.dart';
import 'package:smart_advisor/app/core/utils/constants/app_style.dart';
import 'package:smart_advisor/app/features/manage_license_flow/presentation/blocs/main_flow_bloc/main_flow_bloc.dart';
import 'package:smart_advisor/app/features/shared_features/widgets/check_box_item.dart';

class DeleteActivitives extends StatefulWidget {
  static String title = "DeleteActivitives";

  const DeleteActivitives({super.key});

  @override
  State<DeleteActivitives> createState() => _DeleteActivitivesState();
}

class _DeleteActivitivesState extends State<DeleteActivitives> {
  List addetionalActivitesResponse = [
    {'id': 1, "activityName": 'تموينات ضمن محطة وقود'},
    {
      'id': 2,
      "activityName":
          'كوفي شوب داخل التموينات في مراكز الخدمة ومحطات الوقود فئة أ و ب'
    },
    {
      'id': 3,
      "activityName":
          'البيع بالتجزئة لوقود السيارات والدراجات النارية  محطات الوقود'
    },
    {'id': 4, "activityName": 'كوفي شوب داخل التموينات '},
    {
      'id': 5,
      "activityName":
          'كوفي شوب داخل التموينات في مراكز الخدمة ومحطات الوقود فئة أ و ب'
    },
    {
      'id': 6,
      "activityName":
          'البيع بالتجزئة لوقود السيارات والدراجات النارية  محطات الوقود'
    }
  ];

// List to track selected states of the checkboxes
  late List<bool> selectedValues;

  @override
  void initState() {
    super.initState();
    // Initialize selectedValues based on the length of addetionalActivitesResponse
    selectedValues = List<bool>.filled(
        addetionalActivitesResponse.length, false); // All unchecked by default
    context.read<ManageMainFlowBloc>().add(const ChangeValueEvent(
          currentPagesNumber: 5,
          editSelection: 2,
          isLastEditPage: true,
        ));
  }

  // Function to handle checkbox selection
  void onCheckboxSelected(int index, bool newValue) {
    setState(() {
      selectedValues[index] = newValue;
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
                            "ما الانشطة التي تريد ازالتها لرخصتك ؟",
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
                                  addetionalActivitesResponse.length ?? 0,
                              itemBuilder: (context, index) {
                                return CheckBoxItem(
                                  isDeleting: true,
                                  color: AppColor.white,
                                  currentValue: selectedValues[index],
                                  title: addetionalActivitesResponse[index]
                                          ['activityName'] ??
                                      "",
                                  onSelect: (bool? newValue) {
                                    if (newValue != null) {
                                      onCheckboxSelected(index,
                                          newValue); // Update state on selection
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
                  if ((addetionalActivitesResponse.isEmpty ?? true)) ...[
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
