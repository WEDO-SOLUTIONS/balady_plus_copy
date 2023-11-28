import 'package:balady_plus/app/features/ekram/ekram_exports.dart'
    show EkramBookingCardWidget, getDummyEkramBookingList;
import 'package:flutter/material.dart';

import '../../../../../etmam_app/core/utils/utils_exports.dart' show trans;
import '../../../../../etmam_app/features/_shared_feature_/shared/presentation/widgets/custom_app_bar_widget.dart';
import '../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/search_text_field_widget.dart';

class EkramBookingListPage extends StatefulWidget {
  const EkramBookingListPage({Key? key}) : super(key: key);

  @override
  State<EkramBookingListPage> createState() => _EkramBookingListPageState();
}

class _EkramBookingListPageState extends State<EkramBookingListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: trans('cemetery_booking_requests'),
        withBackImg: true,
      ),
      body: Column(
        children: [
          const CustomVerticalSpace(height: 15),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: SearchTextFieldWidget(
              hintText: trans('search_for_order'),
              onTextChanged: (String v) {},
              onSubmitSearch: (String text) {},
              containerHeight: 52,
            ),
          ),
          const CustomVerticalSpace(height: 15),
          Expanded(
            child: ListView.builder(
                itemCount: getDummyEkramBookingList.length,
                itemBuilder: (ctx, index) {
                  return Column(
                    children: [
                      EkramBookingCardWidget(
                        ekramBookingItem: getDummyEkramBookingList[index],
                      ),
                      CustomVerticalSpace(
                          height: index == (getDummyEkramBookingList.length - 1)
                              ? 30
                              : 12)
                    ],
                  );
                }),
          ),
          //  CustomVerticalSpace(height: 30)
        ],
      ),
    );
  }
}
