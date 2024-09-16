import '../../../../core/services/local/navigation_services.dart';
import '/app/core/utils/utils_exports.dart';
import '/app/features/select_activity/domain/entities/activity_details_page_params.dart';
import '/app/features/select_activity/domain/entities/addetional_activites_page_params.dart';
import '/app/features/shared_features/widgets/app_bar.dart';
import '/app/features/shared_features/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class AreaPage extends StatefulWidget {
  ActivityDetailsPageParams params;
  AreaPage({Key? key, required this.params}) : super(key: key);

  @override
  State<AreaPage> createState() => _AreaPageState();
}

class _AreaPageState extends State<AreaPage> {
  double area = 0;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: CustomAppBar(
          title: "المساحة",
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ما هي المساحه التقريبيه للمنشاه ؟',
                style: AppStyle.heading2BoldStyle
                    .copyWith(color: AppColor.textPrimaryColor),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'اضف مساحه منشأتك',
                  style: AppStyle.captionRomanStyle,
                ),
              ),
              SizedBox(height: 8),
              TextField(
                keyboardType: TextInputType.number,
                textAlign: TextAlign.right,
                onChanged: (String t) {
                  area = double.tryParse(t) ?? 0;
                  setState(() {});
                },
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  hintText: 'متر مربع',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
              Spacer(),
              CustomButton(
                text: 'التالي',
                isDisabled: area <= 0,
                btnColor: AppColor.statusAccentColor,
                onPress: () {
                  NavigationService.navigatorKey.currentState!.pushNamed(
                      RouteName.addetionalActivitesPage,
                      arguments: widget.params.copyWith(area: area));
                },
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
