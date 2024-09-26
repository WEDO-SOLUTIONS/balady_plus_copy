import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/services/local/navigation_services.dart';
import '/app/core/utils/utils_exports.dart';
import '/app/features/select_activity/domain/entities/activity_details_page_params.dart';
import '/app/features/select_activity/domain/entities/addetional_activites_page_params.dart';
import '/app/features/shared_features/widgets/app_bar.dart';
import '/app/features/shared_features/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class AreaPage extends StatefulWidget {
  ActivityDetailsPageParams params;
  AreaPage({
    Key? key,
    required this.params,
  }) : super(key: key);

  @override
  State<AreaPage> createState() => _AreaPageState();
}

class _AreaPageState extends State<AreaPage> {
  double area = 0;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        height: 440,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: ListView(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        bottom: 8.0,
                      ),
                      child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppColor.textPrimaryColor.withOpacity(.10),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(6)),
                          )),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'المساحة التقريبية للمنشاة',
                        style: AppStyle.heading2BoldStyle
                            .copyWith(color: AppColor.textPrimaryColor),
                        textAlign: TextAlign.center,
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          height: 40,
                          width: 64,
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.2),
                            //AppColor.surfaceSecondaryColor,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: IconButton(
                            onPressed: () {
                              NavigationService.navigatorKey.currentState!
                                  .pop(context);
                            },
                            icon: Icon(
                              Icons.close,
                              size: 24,
                              color:
                                  AppColor.textPrimaryColor.withOpacity(0.70),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Center(
                      child: Stack(children: [
                    SvgPicture.asset(
                        'packages/smart_advisor/smart_advisor_assets/images/BgmeterScale.svg'),
                    Image.asset(
                        'packages/smart_advisor/smart_advisor_assets/images/meterScale.png'),
                  ])),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'اضف مساحه منشأتك',
                      style: AppStyle.textRegularStyle
                          .copyWith(color: Color(0xff1B1B1B)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.right,
                      onChanged: (String t) {
                        area = double.tryParse(t) ?? 0;
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 16.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.teal),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.teal),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.teal),
                        ),
                        // filled: true,
                        fillColor: Colors.grey[200],
                        suffixText: 'متر مربع',
                        // hintText: 'متر مربع',
                        hintStyle: const TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                  // const Spacer(),
                  const SizedBox(
                    height: 25,
                  ),
                  CustomButton(
                    text: 'استمرار',
                    btnHeight: 45,
                    isDisabled: area <= 0,
                    btnColor: AppColor.primary,
                    onPress: () {
                      NavigationService.navigatorKey.currentState!.pushNamed(
                          RouteName.addetionalActivitesPage,
                          arguments: widget.params.copyWith(area: area));
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
