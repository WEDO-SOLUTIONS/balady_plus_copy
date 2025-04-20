import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_advisor/app/core/utils/constants/app_colors.dart';
import 'package:smart_advisor/app/core/utils/constants/app_style.dart';
import 'package:smart_advisor/app/features/home_page/presentation/widgets/area_widget.dart';
import 'package:smart_advisor/app/features/manage_license_flow/presentation/blocs/main_flow_bloc/main_flow_bloc.dart';
import 'package:smart_advisor/app/features/manage_license_flow/presentation/widgets/warning_widget.dart';

class RenewalPeriodPage extends StatefulWidget {
  const RenewalPeriodPage({super.key});

  @override
  State<RenewalPeriodPage> createState() => _RenewalPeriodPageState();
}

class _RenewalPeriodPageState extends State<RenewalPeriodPage> {
  int _selectedIndex = -1;
  List dataList = [
    {
      "period": "1",
      "fee": "30",
    },
    {
      "period": "2",
      "fee": "60",
    },
    {
      "period": "3",
      "fee": "80",
    }
  ];
  @override
  void initState() {
    super.initState();
    context.read<ManageMainFlowBloc>().add(const ChangeValueEvent(
          currentPagesNumber: 3,
          isLastRenewPage: true,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                      "ما مدة التجديد التي ترغب بها؟",
                      style: AppStyle.somarSemiBold
                          .copyWith(color: AppColor.textPrimaryColor),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      "تعرض القائمة الرخص المدرجة تحت السجل ",
                      style: AppStyle.textRegularStyle
                          .copyWith(color: AppColor.textSecondaryColor),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    MediaQuery.removePadding(
                      removeTop: true,
                      removeBottom: true,
                      context: context,
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: dataList.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: AreaWidget(
                              title: "${dataList[index]["period"]} سنة",
                              // description: "",
                              /* "الرسوم: ${dataList[index]["fee"]} ريال",*/
                              onSelect: () {
                                setState(() {
                                  _selectedIndex = index;
                                });
                              },
                              isActive: true,
                              isSelected: _selectedIndex == index,
                            ),
                          );
                        },
                      ),
                    ),
                    //   const WarningWidget(),
                  ],
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
