import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/features/vd/presentation/widgets/summery_widgets/field_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/constants.dart';
import '../../../../../core/utils/constants/paths/icon_paths.dart';
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
                SvgPicture.asset(
                  IconPath.documentCopy,
                  height: 80,
                  width: 140,
                ),
                const CustomVerticalSpace(
                  height: 26,
                ),
                CustomTextWidget(
                  ('final_inquiry_result').tr(),
                  fontSize: 20,
                  fontWeight: AppFontWeight.bold,
                  fontColor: AppColor.black500,
                ),
                const CustomVerticalSpace(
                  height: 20,
                ),
                FieldData(
                  title: ('transaction_number').tr(),
                  subTitle:
                      widget.result.data?.result?[0].referenceNumber ?? "",
                ),
                CustomVerticalSpace(height: 8),
                FieldData(
                  title: ('letter_number').tr(),
                  subTitle:
                      widget.result.data?.result?[0].eXternalReference ?? "",
                ),
                CustomVerticalSpace(height: 8),
                FieldData(
                  title: ('transaction_date_AH').tr(),
                  subTitle:
                      widget.result.data?.result?[0].creationDateHijri ?? "",
                ),
                CustomVerticalSpace(height: 8),
                FieldData(
                    title: ('transaction_date_AD').tr(),
                    subTitle:
                        widget.result.data?.result?[0].creationDate ?? ""),
                Container(
                  color: Color(0xFFF5F8FA),
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
        CustomVerticalSpace(height: 32),
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: CustomTextWidget(
            "inquiery_path".tr(),
            fontColor: Color(0xFF52525B),
            fontSize: 20,
            fontWeight: AppFontWeight.bold,
          ),
        ),
        CustomVerticalSpace(height: 32),
        /* Row(
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
        ),*/
        ListView.builder(
          shrinkWrap: true,
          itemCount: itemsFrom.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (ctx, index) {
            return Container(
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.circular(8)),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomTextWidget(
                              ("source").tr(),
                              fontWeight: AppFontWeight.bold,
                              textAlign: TextAlign.start,
                              fontColor: AppColor.primary900Light,
                              fontSize: 15,
                            ),
                            CustomVerticalSpace(height: 16),
                            CustomTextWidget(
                              itemsFrom[index],
                              fontColor: AppColor.black500,
                              textAlign: TextAlign.start,
                              fontWeight: AppFontWeight.medium,
                              fontSize: 13,
                              maxLines: 100,
                            ),
                          ],
                        ),
                      ),
                      CustomHorizontalSpace(width: 4),
                      Expanded(
                        child: Column(
                          children: [
                            CustomTextWidget(
                              ("current_management").tr(),
                              fontWeight: AppFontWeight.bold,
                              textAlign: TextAlign.start,
                              fontColor: AppColor.primary900Light,
                              fontSize: 15,
                            ),
                            CustomVerticalSpace(height: 16),
                            CustomTextWidget(
                              itemsTo[index],
                              fontColor: AppColor.black500,
                              textAlign: TextAlign.start,
                              fontWeight: AppFontWeight.medium,
                              fontSize: 13,
                              maxLines: 100,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  CustomVerticalSpace(height: 20)
                ],
              ),
            );
          },
        )
      ],
    );
  }
}
