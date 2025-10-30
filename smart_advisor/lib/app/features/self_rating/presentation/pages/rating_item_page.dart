import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_advisor/app/features/shared_features/new_app_bar.dart';

import '../../../../core/services/local/navigation_services.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/app_style.dart';
import '../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../shared_features/widgets/custom_button.dart';
import '../../data/models/rating_items_response.dart';

class RatingItemPage extends StatefulWidget {
  final List<RatingItemsResponseItem> items;
  final String title;
  const RatingItemPage({super.key, required this.items, required this.title});

  @override
  State<RatingItemPage> createState() => _RatingItemPageState();
}

class _RatingItemPageState extends State<RatingItemPage> {
  List<RatingItemsResponseItem> originalItems = [];

  List<RatingItemsResponseItem> items = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    items = [...widget.items];
    originalItems = [...widget.items];

    items = items.where((e) => e.isDuplicated != true).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ClausesAppBar(
            title: widget.title,
            total: items.length ?? 0,
            completed: items.where((e) => e.isClausesValidated != null).length,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: MediaQuery.removePadding(
                removeTop: true,
                context: context,
                child: ListView.builder(
                    itemCount: items.length,
                    shrinkWrap: true,
                    // physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (ctx, index) {
                      return RatingWidgetItem(
                        index: index + 1,
                        item: items[index],
                        onSelect: (value) {
                          int originalIndex = originalItems.indexWhere(
                              (e) => e.subClauseNo == items[index].subClauseNo);

                          originalItems[originalIndex].isClausesValidated =
                              value;
                          items[index].isClausesValidated = value;

                          setState(() {});
                        },
                      );
                    }),
              ),
            ),
          ),
          Container(
            height: 100,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: CustomButton(
                btnHeight: 52,
                onPress: () {
                  Navigator.of(context).pop(items);
                },
                text: "حفظ"),
          )
        ],
      ),
    );
  }
}

class RatingWidgetItem extends StatelessWidget {
  final RatingItemsResponseItem item;
  final int index;

  final Function(int value) onSelect;

  const RatingWidgetItem(
      {super.key,
      required this.item,
      required this.onSelect,
      required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 16, left: 16, top: 16, bottom: 16),
      alignment: Alignment.center,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          width: 1,
          color: const Color(0xffE2E9F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${index}. ${item.subClauseName ?? ""}",
            style: AppStyle.textRegularRomanStyle.copyWith(
              color: const Color(0xA1465463),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ComponentItem(
                isClauseValidated: item.isClausesValidated == 1,
                index: 0,
                onTap: () => onSelect(1),
                text: "ممتثل",
                icon:
                    'packages/smart_advisor/smart_advisor_assets/icons/svg/user-smile-fill@2x.svg',
              ),
              ComponentItem(
                isClauseValidated: item.isClausesValidated == 2,
                index: 2,
                onTap: () => onSelect(2),
                text: "غير ممتثل",
                icon:
                    'packages/smart_advisor/smart_advisor_assets/icons/svg/emotion-sad-fill.svg',
              ),
              ComponentItem(
                isClauseValidated: item.isClausesValidated == 3,
                index: 1,
                onTap: () => onSelect(3),
                text: "لا ينطبق",
                icon:
                    'packages/smart_advisor/smart_advisor_assets/icons/svg/Info.svg',
              ),
            ],
          )
        ],
      ),
    );
  }
}

class ComponentItem extends StatelessWidget {
  final bool? isClauseValidated;
  final String text;
  final String icon;
  final Function onTap;
  final int index;

  const ComponentItem(
      {super.key,
      this.isClauseValidated,
      required this.text,
      required this.onTap,
      required this.index,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        height: 38,
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.only(top: 8),
        decoration: BoxDecoration(
          color: getColorBg(index, isClauseValidated ?? false),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            width: 1,
            color: getColorBorder(index, isClauseValidated ?? false),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              icon,
              color: getColorBorder(index, isClauseValidated ?? false),
            ),
            const SizedBox(
              width: 4,
            ),
            Text(
              text,
              style: AppStyle.textRegularRomanStyle.copyWith(
                fontSize: 12,
                color: isClauseValidated == true
                    ? getTextColor(index)
                    : const Color(0xA1465463),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to determine border color based on selection
  Color getColorBorder(int index, bool isSelected) {
    switch (index) {
      case 0:
        return isSelected ? const Color(0xFF568F64) : const Color(0xFFD7DEE4);
      case 1:
        return isSelected ? const Color(0x9E1E2A36) : const Color(0xFFD7DEE4);
      case 2:
        return isSelected ? const Color(0xFFFFA726) : const Color(0xFFD7DEE4);
      default:
        return const Color(0xFFE2E9F0);
    }
  }

  // Function to determine background color based on selection
  Color getColorBg(int index, bool isSelected) {
    switch (index) {
      case 0:
        return isSelected
            ? const Color(0x15568F64)
            : const Color(0xFFF8FAFC); // Light Green
      case 1:
        return isSelected
            ? const Color(0x10568F64)
            : const Color(0xFFF8FAFC); // Light Gray
      case 2:
        return isSelected ? const Color(0x1AFA8B64) : const Color(0xFFF8FAFC);

      /// Light Orange
      default:
        return const Color(0xFFF8FAFC);
    }
  }

  // Function to determine text color based on selection
  Color getTextColor(int index) {
    switch (index) {
      case 0:
        return const Color(0xFF568F64); // Green
      case 1:
        return const Color(0xFFA7A7A7); // Gray
      case 2:
        return const Color(0xFFFFA726); // Orange
      default:
        return const Color(0xFFA7A7A7);
    }
  }
}

class ClausesAppBar extends StatelessWidget {
  final String title;
  final int total;
  final int completed;
  const ClausesAppBar(
      {super.key,
      required this.title,
      required this.completed,
      required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          colors: [
            Color(0x3398FCFF), // 20% opacity
            Color(0x00ADC587), // 0% opacity
          ],
          radius:
              1.0, // Adjust the radius to control the spread of the gradient
          center: Alignment.topLeft, // Set the center of the gradient
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
          bottom: 12,
          left: 12,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    NavigationService.navigatorKey.currentState!.pop(context);
                  },
                  icon: SvgPicture.asset(
                    IconPath.newBackIcon,
                    width: 24,
                    height: 24,
                    color: AppColor.textPrimaryColor, //statusAccentColor,
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          maxLines: 1,
                          style: AppStyle.callout1BoldStyle
                              .copyWith(color: AppColor.textPrimaryColor),
                        ),
                      ),
                    ],
                  ),
                ),
                CircularProgressWithText(
                  completed: completed,
                  total: total,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CircularProgressWithText extends StatelessWidget {
  final int total;
  final int completed;

  CircularProgressWithText({required this.total, required this.completed});

  @override
  Widget build(BuildContext context) {
    double progress = completed / total;

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 60,
          height: 60,
          child: CircularProgressIndicator(
            value: progress,
            strokeWidth: 5.0,
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xff568F64)),
          ),
        ),
        Text(
          '$completed/$total',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }
}
