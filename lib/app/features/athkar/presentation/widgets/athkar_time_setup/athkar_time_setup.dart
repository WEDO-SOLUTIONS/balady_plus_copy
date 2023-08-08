import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/components/bottom_sheets/bottom_sheet_with_actions.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/components/bottom_sheets/draggable_sheet_component.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/dialogs/bottom_sheet_dialogs.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';
import 'package:balady_plus/app/features/athkar/data/datasources/static_athkar_data.dart';
import 'package:balady_plus/app/features/athkar/domain/entities/athkar_category.dart';
import 'package:balady_plus/app/features/athkar/presentation/widgets/athkar_time_setup/timer.dart';
import 'package:bottom_picker/bottom_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class AthkarTimeSetup extends StatefulWidget {
  AthkarTimeSetup({super.key});

  @override
  State<AthkarTimeSetup> createState() => _AthkarTimeSetupState();
}

class _AthkarTimeSetupState extends State<AthkarTimeSetup> {
  final List athkarList = StaticAthkarData.athkarCategories;
  DateTime time = DateTime(2016, 5, 10, 22, 35);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: athkarList.length,
        itemBuilder: (context, index) {
          final AthkarCategory athkarCategory = athkarList[index];
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(athkarCategory.icon),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          athkarCategory.name,
                          style: AppStyle.athkarNameStyle,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(230, 239, 239, 0.50),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: GestureDetector(
                            onTap: () async {
                              showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return Container(
                                    height: 216,
                                    color: CupertinoColors.systemBackground
                                        .resolveFrom(context),
                                    child: SafeArea(
                                      top: false,
                                      child: CupertinoDatePicker(
                                        initialDateTime: time,
                                        mode: CupertinoDatePickerMode.time,
                                        use24hFormat: true,
                                        onDateTimeChanged: (DateTime newTime) {
                                          setState(() => time = newTime);
                                        },
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: Text(
                              '${time.hour}:${time.minute}',
                              style: AppStyle.athkarTimeStyle,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 19,
                        ),
                        const CustomSvgIconWidget(
                          IconPath.notificationOn,
                          iconSize: 25,
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
