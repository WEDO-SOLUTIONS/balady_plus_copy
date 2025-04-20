import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_advisor/app/features/select_activity/domain/entities/suggested_area_model.dart';
import 'package:smart_advisor/app/features/select_activity/presentation/blocs/main_flow_bloc/main_flow_bloc.dart';

import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/app_style.dart';
import '../../../../home_page/presentation/widgets/area_widget.dart';

class Step11Page extends StatefulWidget {
  static String title = "Step11Page";
  const Step11Page({super.key});

  @override
  State<Step11Page> createState() => _Step11PageState();
}

class _Step11PageState extends State<Step11Page> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainFlowBloc, MainFlowState>(
      builder: (context, state) {
        List<SuggestedAreaModel> list = state.suggestedAreas();
        return Padding(
          padding: const EdgeInsets.only(
            right: 16.0,
            left: 16,
          ),
          child: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'ما هي المساحة التقديرية للمنشأة الخاصة بك؟',
                    textAlign: TextAlign.center,
                    style: AppStyle.somarSemiBold
                        .copyWith(color: AppColor.textPrimaryColor),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'المساحات المتاحة لك حسب نشاطك',
                    textAlign: TextAlign.center,
                    style: AppStyle.textRegularStyle
                        .copyWith(color: AppColor.textSecondaryColor),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(
                          0xFFF9F5F4), // Light background color similar to the image
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(
                            0xFFE7DAD9), // Border color similar to the image
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        /* Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SvgPicture.asset(
                                'packages/smart_advisor/smart_advisor_assets/icons/svg/warning.svg'),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              'تنبيه',
                              style: AppStyle.textRegularRomanStyle
                                  .copyWith(color: AppColor.textPrimaryColor),
                            ),
                          ],
                        ),*/
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          ' يشترط نشاط "${state.selectedActivity?.name}..." '
                          'الذي قمت باختياره أن لا تقل مساحة المحل عن ${state.selectedActivity?.minArea} وان لا تزيد عن ${state.selectedActivity?.maxArea}',
                          style: AppStyle.footNoteRomanStyle
                              .copyWith(color: AppColor.textSecondaryColor),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  MediaQuery.removePadding(
                    removeTop: true,
                    context: context,
                    child: ListView.builder(
                        itemCount: list.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              AreaWidget(
                                  onSelect: () {
                                    context.read<MainFlowBloc>().add(
                                        ChangeValuesEvent(
                                            selectedArea: list[index]));
                                  },
                                  title: list[index].getItem(),
                                  description: list[index].desc,
                                  isSelected:
                                      list[index].id == state.selectedArea?.id,
                                  isActive: list[index].isActive),
                              const SizedBox(height: 12),
                            ],
                          );
                        }),
                  ),
                  const SizedBox(
                    height: 20,
                  )
                ]),
          ),
        );
      },
    );
  }
}
