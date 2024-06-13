import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/default_appbar_widget.dart';
import 'package:balady_plus/app/features/profile_features/delegators/presentation/delegators_cubit/delegators_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class NotificationsDetailsScreen extends StatelessWidget {
  const NotificationsDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DelegatorsCubit>.value(
      value: sl<DelegatorsCubit>(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: DefaultAppBarWidget(
          title: "notifications".tr(),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 3,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              "تم اصدار الفتورة",
                              style: AppStyle.signInFullTextStyle
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(width: 4),
                            Card(
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6)),
                              ),
                              color: Colors.red.shade800.withAlpha(60),
                              elevation: 0,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: Text(
                                  "تنبية",
                                  style: AppStyle.nearbyItemSubTitleTextStyle
                                      .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red.shade800,
                                  ),
                                ),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              " 5:31  صباحا , اليوم",
                              style:
                                  AppStyle.nearbyItemSubTitleTextStyle.copyWith(
                                fontWeight: FontWeight.w500,
                                fontSize: 11,
                                color: AppColor.warmGrey2,
                              ),
                            ),
                          ],
                        ),
                        const Text(
                          "نأمل منك تحديث بيانات رخصة رقم 349350349 تجنبًا للغرامات"
                          "اسم المالك: محمد فهد الحربي"
                          "\nرقم الرخصة: 349350349"
                          "\nتاريخ رصد المخالفة: 04/01/2024"
                          "سبب المخالفة: عدم مطابقة بيانات الرخصة للأنشطة المضافة \n",
                        ),
                        const SizedBox(height: 12),
                        ElevatedButtonWidget.custom(
                          onPressed: () {},
                          text: 'تحديث الرخصة',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // ),
      ),
    );
  }
}
