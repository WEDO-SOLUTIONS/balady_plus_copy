/*import 'package:flutter/material.dart';

import '../../../../../core/services/local/helpers.dart';
import '../../../../../core/utils/constants/constants.dart';

class BillBodySectionWidget extends StatelessWidget {
  const BillBodySectionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        // request data
        _RequestDataWidget(),
        // bill info
        _BillInfoWidget(),
        // // bill details
        _BillDetailsWidget(),
        Constants.verticalSpaceLarge,
      ],
    );
  }
}

class _RequestDataWidget extends StatelessWidget {
  const _RequestDataWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomEnhancedExpansionPanelWidget(
      title: Helpers.translatingWord("health_bill_order"),
      underline: false,
      child: null,
    );
  }
}

class _BillInfoWidget extends StatelessWidget {
  const _BillInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomEnhancedExpansionPanelWidget(
      title: Helpers.translatingWord("health_bill_info"),
      underline: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTitleSubtitleCardWidget(
            horizontalPadding: Constants.smallPadding,
            title: Helpers.translatingWord("health_bill_date"),
            subtitle: '2021 / 1 / 5',
          ),
          CustomTitleSubtitleCardWidget(
            horizontalPadding: Constants.smallPadding,
            title: Helpers.translatingWord("health_bill_end_date"),
            subtitle: ' 2021 / 1 / 5',
          ),
          CustomTitleSubtitleCardWidget(
            horizontalPadding: Constants.smallPadding,
            title: Helpers.translatingWord("health_bill_saddad"),
            subtitle: '4234234123',
          ),
        ],
      ),
    );
  }
}

class _BillDetailsWidget extends StatelessWidget {
  const _BillDetailsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomEnhancedExpansionPanelWidget(
      title: Helpers.translatingWord("bill_info"),
      underline: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _BillDetailsCardWidget(
              label: Helpers.translatingWord("health_bill_issue"), price: 2000),
          Constants.verticalSpaceSmall,
          DrawLineWidget(),
          Constants.verticalSpaceSmall,
          _BillDetailsCardWidget(
              label: Helpers.translatingWord("health_bill_total"),
              totalPrice: 2000),
        ],
      ),
    );
  }
}

class _BillDetailsCardWidget extends StatelessWidget {
  final String label;
  final double? price;
  final double? totalPrice;
  const _BillDetailsCardWidget({
    Key? key,
    required this.label,
    this.price,
    this.totalPrice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Constants.semiMediumPadding,
      ),
      child: Row(
        children: [
          // icon
          Container(
            width: 4.0,
            height: 4.0,
            decoration: BoxDecoration(
              color: totalPrice == null
                  ? AppColor.baladyDarkGreen2
                  : Colors.transparent,
              shape: BoxShape.circle,
            ),
          ),
          Constants.horizontalSpaceSmall,
          Expanded(
            child: LayoutBuilder(
              builder: (_, constraints) {
                final width = constraints.maxWidth;
                return Row(
                  children: [
                    // label
                    SizedBox(
                      width: width * 0.70,
                      child: CustomTextWidget(
                        label,
                        fontColor: AppColor.black700,
                        fontSize: 13.0,
                        textAlign: TextAlign.start,
                      ),
                    ),
                    // price
                    SizedBox(
                      width: width * 0.30,
                      child: RichText(
                        textScaleFactor: 1,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        textAlign: TextAlign.end,
                        text: TextSpan(
                          text: _getPrice(),
                          style: const TextStyle(
                            color: AppColor.black,
                            fontSize: 16.0,
                            fontFamily: Constants.appFontType,
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                            TextSpan(text: '  '),
                            TextSpan(
                              text:
                                  Helpers.translatingWord("health_bill_riyal"),
                              style: TextStyle(
                                color: AppColor.black500,
                                fontSize: 13.0,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getPrice() {
    if (price != null && totalPrice == null) {
      return '$price';
    } else if (price == null && totalPrice != null) {
      return '$totalPrice';
    } else {
      return '0';
    }
  }
}
*/
