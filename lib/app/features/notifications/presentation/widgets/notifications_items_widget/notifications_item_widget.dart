import 'package:balady_plus/app/features/notifications/presentation/widgets/notifications_items_widget/expandable_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';

class NotificationsItemWidget extends StatelessWidget {
  // final List<CalendarEventItem> listEvents;

  const NotificationsItemWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 3,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(
                IconPath.bookIcon,
              ),
              const SizedBox(width: 6),
              Expanded(
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
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Text(
                              "تنبية",
                              style:
                                  AppStyle.nearbyItemSubTitleTextStyle.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.red.shade800,
                              ),
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                          ),
                          color: Colors.red.shade800.withAlpha(60),
                          elevation: 0,
                        ),
                        const Spacer(),
                        Text(
                          " 5:31  صباحا , اليوم",
                          style: AppStyle.nearbyItemSubTitleTextStyle.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 11,
                            color: AppColor.warmGrey2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ExpandableTextWidget(
                      text:
                      "نأمل منك تحديث بيانات رخصة رقم 349350349 تجنبًا للغرامات"
                          "اسم المالك: محمد فهد الحربي"
                          "\nرقم الرخصة: 349350349"
                          "\nتاريخ رصد المخالفة: 04/01/2024"
                          "سبب المخالفة: عدم مطابقة بيانات الرخصة للأنشطة المضافة \n",

                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
