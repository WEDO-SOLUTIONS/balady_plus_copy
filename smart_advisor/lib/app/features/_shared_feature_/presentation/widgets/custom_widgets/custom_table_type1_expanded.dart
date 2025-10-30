import '../../../../documents/models/custom_table_type1_model.dart';
import '/app/core/utils/constants/app_colors.dart';
import '/app/core/utils/constants/app_style.dart';
import '/app/features/_shared_feature_/presentation/widgets/custom_table_type1.dart';
import 'package:flutter/material.dart';

class CustomTableType1Expanded extends StatefulWidget {
  final CustomTableTypeModel item;
  const CustomTableType1Expanded({super.key, required this.item});

  @override
  State<CustomTableType1Expanded> createState() =>
      _CustomTableType1ExpandedState();
}

class _CustomTableType1ExpandedState extends State<CustomTableType1Expanded> {
  bool isViewDetail = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "قائمة التدقيق  للمتطلبات المكانية",
              style: AppStyle.heading2BoldStyle
                  .copyWith(color: AppColor.textPrimaryColor),
            ),
            // SvgPicture.asset('assets/icons/svg/arrowR.svg'),
            IconButton(
                onPressed: () {
                  setState(() {
                    isViewDetail = !isViewDetail;
                  });
                },
                icon: isViewDetail
                    ? Icon(Icons.chevron_left)
                    : Icon(Icons.keyboard_arrow_down_sharp)),
          ],
        ),
        if (isViewDetail == true)
          CustomTableType1(
            description:
                "يكون المركز ضمن دور أرضي أو أرضي وميزانين ويستثنى من ذلك أن يكون ضمن الأدوار المتكررة في المباني التجارية، والمجمعات التجارية، ومرافق الإيواء السياحي المصنفة أربعة نجوم أو أكثر، أو ما يعادلها.",
            subCategories: ["متطلبات الموقع", "جزء من مبني قائم", "gggg"],
          )
      ],
    );
  }
}
