import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/features/vd/presentation/widgets/summery_widgets/field_data.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/constants.dart';
import '../../../../_shared_feature_/presentation/widgets/check_boxes/custom_box_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/draw_line_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../core/models/inquiry_transaction_response.dart';

class InquiryBody extends StatefulWidget {
  InquiryTransactionResponse result;

  InquiryBody({Key? key, required this.result}) : super(key: key);

  @override
  State<InquiryBody> createState() => _InquiryBodyState();
}

class _InquiryBodyState extends State<InquiryBody> {
  List<String> transfersItemsFrom = [];

  List<String> transfersItemsTo = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.result != null &&
        widget.result.data != null &&
        widget.result.data?.result != null &&
        widget.result.data!.result!.isNotEmpty &&
        widget.result.data?.result?[0].transfers != null &&
        widget.result.data!.result![0].transfers!.isNotEmpty) {
      List<Transfer> t = widget.result.data!.result![0].transfers!;
      t.forEach((element) {
        transfersItemsFrom.add(element.transferFromDept ?? "");
        transfersItemsTo.add(element.transferToDept ?? "");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                const CustomVerticalSpace(height: 20),
                Image.asset(
                  Constants.imgPath + "inquiryIllustration@3x.png",
                  height: 80,
                  width: 140,
                ),
                const CustomVerticalSpace(
                  height: 26,
                ),
                CustomTextWidget(
                  ('final_inquiry_result').tr(),
                  fontSize: 19,
                  fontWeight: AppFontWeight.medium,
                  fontColor: AppColor.black500,
                ),
                const CustomVerticalSpace(
                  height: 20,
                ),
                InquiryCard(
                  id: widget.result.data?.result?[0].referenceNumber ?? "",
                  letterNumber:
                      widget.result.data?.result?[0].eXternalReference ?? "",
                ),
                Container(
                  margin: const EdgeInsetsDirectional.only(start: 8),
                  child: FieldData(
                    title: ('transaction_date').tr(),
                  ),
                ),
                Container(
                  margin: const EdgeInsetsDirectional.only(start: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: InquiryDateWidget(
                          title: ('transaction_date_AH').tr(),
                          desc: widget
                                  .result.data?.result?[0].creationDateHijri ??
                              "",
                        ),
                      ),
                      const CustomHorizontalSpace(width: 2),
                      Expanded(
                        child: InquiryDateWidget(
                          title: ('transaction_date_AD').tr(),
                          desc:
                              widget.result.data?.result?[0].creationDate ?? "",
                        ),
                      )
                    ],
                  ),
                ),
                // const CustomVerticalSpace(height: 38),
                const DrawLineWidget(verticalMargin: 24),
                Container(
                  margin: const EdgeInsetsDirectional.only(start: 16),
                  child: InquiryListWidget(
                    itemsFrom: transfersItemsFrom,
                    itemsTo: transfersItemsTo,
                  ),
                ),
                const CustomVerticalSpace(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class InquiryCard extends StatelessWidget {
  final String letterNumber;
  final String id;

  const InquiryCard({Key? key, required this.letterNumber, required this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          boxShadow: [
            BoxShadow(
                color: Color(0x1a000000),
                offset: Offset(0, 2),
                blurRadius: 10,
                spreadRadius: 0)
          ],
          color: Colors.white),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomTextWidget(
                ('inquiry_info').tr(),
                fontColor: AppColor.black,
                fontSize: 17,
              ),
              Image.asset(
                Constants.imgPath + 'inquiryIcon@3x.png',
                height: 42,
                width: 42,
              ),
            ],
          ),
          const Opacity(
            opacity: 0.2000000029802322,
            child: DrawLineWidget(
              verticalMargin: 24,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: InquiryDateWidget(
                  title: ('transaction_number').tr(),
                  desc: id,
                  img: "streamlineIconHash10X10@3x.png",
                ),
              ),
              const CustomHorizontalSpace(width: 2),
              Expanded(
                child: InquiryDateWidget(
                  title: ('letter_number').tr(),
                  desc: letterNumber,
                  img: "iconStroke24EssentialLettterId@3x.png",
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class InquiryDateWidget extends StatelessWidget {
  String title;
  String desc;
  String? img;

  InquiryDateWidget(
      {Key? key, required this.title, required this.desc, this.img})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (img != null)
              Image.asset(
                Constants.imgPath + img!,
                height: 14.0,
                width: 14.0,
                color: AppColor.black400,
              ),
            if (img != null) const CustomHorizontalSpace(width: 5),
            CustomTextWidget(
              title,
              fontSize: 13,
              fontWeight: AppFontWeight.medium,
              fontColor: AppColor.warmGrey,
              textAlign: TextAlign.start,
            ),
          ],
        ),
        const CustomVerticalSpace(height: 15),
        CustomTextWidget(
          desc,
          fontColor: AppColor.black,
          textAlign: TextAlign.start,
          fontSize: (img != null) ? 13 : 16,
          fontFamily: Constants.lucidaGrandFontType,
        ),
      ],
    );
  }
}

class InquiryListWidget extends StatelessWidget {
  List<String> itemsFrom;
  List<String> itemsTo;

  InquiryListWidget({Key? key, required this.itemsFrom, required this.itemsTo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: CustomTextWidget(
                ("source").tr(),
                fontWeight: AppFontWeight.medium,
                fontColor: AppColor.black,
                textAlign: TextAlign.start,
              ),
            ),
            Expanded(
              child: CustomTextWidget(
                ("current_management").tr(),
                fontWeight: AppFontWeight.medium,
                fontColor: AppColor.black,
                textAlign: TextAlign.start,
              ),
            )
          ],
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: itemsFrom.length,
          padding: const EdgeInsets.only(top: 23),
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (ctx, index) {
            return Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomBoxWidget(
                      size: 6.0,
                      margin: EdgeInsetsDirectional.only(end: 8, top: 3),
                      radius: 4,
                      color: AppColor.baladyDarkGreen2,
                    ),
                    Expanded(
                      child: CustomTextWidget(
                        itemsFrom[index],
                        fontColor: AppColor.black500,
                        textAlign: TextAlign.start,
                        fontWeight: AppFontWeight.medium,
                        fontSize: 13,
                      ),
                    ),
                    CustomHorizontalSpace(width: 4),
                    const CustomBoxWidget(
                      size: 6.0,
                      margin: EdgeInsetsDirectional.only(end: 8, top: 3),
                      radius: 4,
                      color: AppColor.baladyDarkGreen2,
                    ),
                    Expanded(
                      child: CustomTextWidget(
                        itemsTo[index],
                        fontColor: AppColor.black500,
                        textAlign: TextAlign.start,
                        fontWeight: AppFontWeight.medium,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                CustomVerticalSpace(height: 20)
              ],
            );
          },
        )
      ],
    );
  }
}
