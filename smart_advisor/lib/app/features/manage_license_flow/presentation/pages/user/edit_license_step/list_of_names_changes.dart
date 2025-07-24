import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_advisor/app/core/utils/constants/app_colors.dart';
import 'package:smart_advisor/app/core/utils/constants/app_style.dart';
import 'package:smart_advisor/app/features/home_page/presentation/widgets/area_widget.dart';
import 'package:smart_advisor/app/features/manage_license_flow/presentation/blocs/main_flow_bloc/main_flow_bloc.dart';
import 'package:smart_advisor/app/features/manage_license_flow/presentation/widgets/warning_widget.dart';

class ListOfNamesChanges extends StatefulWidget {
  const ListOfNamesChanges({super.key});

  @override
  State<ListOfNamesChanges> createState() => _ListOfNamesChangesState();
}

class _ListOfNamesChangesState extends State<ListOfNamesChanges> {
  int _selectedIndex = -1;
  List dataList = [
    {
      "changeName": "تغيير النشاط الأساسي",
    },
    {
      "changeName": "إضافة أنشطة تجارية",
    },
    /* {
      "changeName": "إزالة بعض الأنشطة",
    }*/
  ];

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
                      "ما التغييرات التي تود إجراؤها على رخصتك؟",
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
                              height: 70,
                              title: "${dataList[index]["changeName"]} ",
                              description: "",
                              onSelect: () {
                                setState(() {
                                  _selectedIndex = index;
                                });
                                context
                                    .read<ManageMainFlowBloc>()
                                    .add(ChangeValueEvent(
                                      currentPagesNumber: 2,
                                      editSelection: index,
                                    ));
                              },
                              isActive: true,
                              isSelected: _selectedIndex == index,
                            ),
                          );
                        },
                      ),
                    ),
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
