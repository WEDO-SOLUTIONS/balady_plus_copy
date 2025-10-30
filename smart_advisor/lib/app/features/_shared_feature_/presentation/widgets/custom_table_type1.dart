import '/app/core/utils/constants/app_colors.dart';
import '/app/core/utils/constants/app_style.dart';
import '/app/features/_shared_feature_/presentation/widgets/custom_widgets/tags_of_tables.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomTableType1 extends StatelessWidget {
  final String description;
  List<String> subCategories;
  CustomTableType1(
      {super.key, required this.description, required this.subCategories});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColor.surfaceSecondaryColor),
      child: Padding(
        padding:
            const EdgeInsets.only(left: 16, right: 16, top: 18, bottom: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              description,
              style: AppStyle.textRegularRomanStyle
                  .copyWith(color: AppColor.textPrimaryColor),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "التصنيفات الفرعيه",
              style: AppStyle.calloutBoldStyle
                  .copyWith(color: AppColor.textPrimaryColor),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of items per row
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 3, // Adjusts the height of each grid item
                ),
                itemCount: subCategories.length, // Number of grid items
                itemBuilder: (context, index) {
                  return TableTag(
                    title: subCategories[index],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildGridItem(String text) {
  return Container(
    alignment: Alignment.center,
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
    decoration: BoxDecoration(
      color: Colors.grey.shade200,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(
      text,
      style: TextStyle(
        fontSize: 16,
        color: Colors.grey.shade700,
      ),
      textAlign: TextAlign.center,
    ),
  );
}
