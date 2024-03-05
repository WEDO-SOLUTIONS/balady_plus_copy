import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/balady_calender/domain/entities/checkbox_entity.dart';
import 'package:balady_plus/app/features/balady_calender/presentation/mvvm/balady_calendar_years_list_view_model.dart';
import 'package:balady_plus/app/features/home_page/home_exports.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

class CalendarFilterPopup extends StatefulWidget {
  const CalendarFilterPopup({super.key});

  @override
  State<CalendarFilterPopup> createState() => _CalendarFilterState();
}

class _CalendarFilterState extends State<CalendarFilterPopup> {
  @override
  Widget build(BuildContext context) {
    BaladyCalendarYearsListViewModel baladyCalendarYearsListViewModel =
        context.watch<BaladyCalendarYearsListViewModel>();
    return Container(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomTextWidget(
                'filter_calendar'.tr(),
                textStyle: AppStyle.sectionTitleStyle,
              ),
              InkWell(
                onTap: () => Navigator.pop(context),
                child: CircleIcon(
                  icon: Icons.close,
                  iconColor: AppColor.primary600Light,
                  backgroundColor: AppColor.geyser.withOpacity(0.5),
                  iconSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'show'.tr(),
            style: AppStyle.serviceCardParameterTitleTextStyle
                .copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          Selector<BaladyCalendarYearsListViewModel,
              List<CheckboxListTileEntity>?>(
            selector: (p0, p1) => p1.checkboListTileEntityList,
            builder: (context, value, child) => Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: value?.length ?? 0,
                itemBuilder: (context, index) {
                  return Selector<BaladyCalendarYearsListViewModel,
                      List<String>>(
                    selector: (p0, p1) => p1.idsSelected,
                    builder: (context, idsSelected, child) =>
                        CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      fillColor: const MaterialStatePropertyAll(
                        AppColor.primary600Light,
                      ),
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text(
                        value![index].name.toString(),
                        style: AppStyle.pickerStyle
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                      value: idsSelected.contains(
                        value[index].id,
                      ),
                      onChanged: (checkedValue) {
                        baladyCalendarYearsListViewModel.selectFilterOption(
                          index,
                          checkedValue!,
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
          SafeArea(
            child: ElevatedButtonWidget.primaryCustom(
              onPressed: () {
                Navigator.of(context).pop(
                  baladyCalendarYearsListViewModel.idsSelected,
                );
              },
              text: 'confirm'.tr(),
            ),
          ),
        ],
      ),
    );
  }
}
