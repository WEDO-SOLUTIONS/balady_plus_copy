import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/components/bottom_sheets/draggable_sheet_component.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/pages/submit_compliance_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../_shared_feature_/presentation/widgets/radio_buttons/custom_radio_button_widget.dart';

class CreateComplianceLocationWidget extends StatefulWidget {
  const CreateComplianceLocationWidget({super.key});

  @override
  State<CreateComplianceLocationWidget> createState() =>
      _CreateComplianceLocationWidgetState();
}

class _CreateComplianceLocationWidgetState
    extends State<CreateComplianceLocationWidget> {
  int selected = 0;

  @override
  Widget build(BuildContext context) {
    return DraggableSheetComponent(
      height: 0.6,
      title: 'riyadh_location_question'.tr(),
      body: Column(children: [
        const SizedBox(
          height: 32,
        ),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: const Color.fromRGBO(
                230,
                239,
                239,
                0.40,
              )),
          child: CustomRadioButtonWidget(
              label: 'Yes'.tr(),
              labelStyle: AppStyle.createComplianceRiyadhRadioStyle,
              radioLabelSpace: 0,
              borderColor: AppColor.athkarAppbarGreen2,
              onSelected: (p0) {
                setState(() {
                  selected = p0;
                });
              },
              radioValue: 0,
              radioGroupValue: selected),
        ),
        const SizedBox(
          height: 16,
        ),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: const Color.fromRGBO(
                230,
                239,
                239,
                0.40,
              )),
          child: CustomRadioButtonWidget(
            label: 'No'.tr(),
            labelStyle: AppStyle.createComplianceRiyadhRadioStyle,
            radioLabelSpace: 0,
            onSelected: (p0) {
              setState(() {
                selected = p0;
              });
            },
            radioValue: 1,
            radioGroupValue: selected,
          ),
        ),
        const SizedBox(
          height: 32,
        ),
        ElevatedButtonWidget.next(onPressed: () {
          if (selected == 1) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const SubmitCompliancePage()));
          } else if (selected == 0) {
            Navigator.of(context).pushNamed(
              RouteName.inappWebview,
              arguments: (
                title: "موقع بلدي الالكتروني",
                url: "https://balady.gov.sa/ar"
              ),
            );
          }
        }),
      ]),
    );
  }
}
