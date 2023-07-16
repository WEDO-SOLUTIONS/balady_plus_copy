import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';

import '../../../../core/services/local/helpers.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/constants.dart';
import '../core/models/health_request_details.dart';

class BillDetailsWidget extends StatelessWidget {
  List<BillFee> fees;
  dynamic totalAmount;
  BillDetailsWidget({Key? key, required this.fees, this.totalAmount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomExpansionPanelWidget(
      title: Helpers.translatingWord("health_bill_details"),
      underline: false,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: fees
                  .map(
                    (e) => BillDetailsCardWidget(
                        label: e.costItemDescription ?? "",
                        price: e.costItemValue.toString()),
                  )
                  .toList(),
            ),
            Column(children: [
              const CustomVerticalSpace(height: 18),
              const DrawLineWidget(),
              const CustomVerticalSpace(height: 18),
              BillDetailsCardWidget(
                  label: Helpers.translatingWord("health_bill_fees"),
                  totalPrice: totalAmount.toString()),
            ])
          ],
        )
      ],
    );
  }
}

class BillDetailsCardWidget extends StatelessWidget {
  final String label;
  final String? price;
  final String? totalPrice;
  const BillDetailsCardWidget({
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
                          children: const [
                            TextSpan(text: '  '),
                            TextSpan(
                              text: 'ريال',
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
