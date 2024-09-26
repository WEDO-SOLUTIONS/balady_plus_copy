import '../../../../core/services/local/navigation_services.dart';
import '/app/features/_shared_feature_/domain/entities/lookUp_response.dart';
import '/app/features/fees_calculator/presentation/widgets/calculator_drop_down.dart';
import '/app/features/fees_calculator/presentation/widgets/calculator_text_field.dart';
import '/app/features/shared_features/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class BoardDialog extends StatefulWidget {
  final Function((LookUpItem, String)) onAdd;
  const BoardDialog({super.key, required this.onAdd});

  @override
  State<BoardDialog> createState() => _BoardDialogState();
}

class _BoardDialogState extends State<BoardDialog> {
  String? area;
  LookUpItem? board;
  List<LookUpItem> boardsItems = [
    LookUpItem(
      id: 1,
      name: "لوحة ارشادية",
    ),
    LookUpItem(
      id: 2,
      name: "لوحة إعلانية",
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 620,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 45, right: 16, left: 26),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CalculatorDropdown(
              title: "",
              onSelect: (LookUpItem item) {
                board = item;
              },
              list: boardsItems,
            ),
            const SizedBox(
              height: 16,
            ),
            CalculatorCustomTextField(
              onChanged: (String? text) {
                area = text;
              },
              title: "المساحة",
              suffix: "متر مربع",
            ),
            const SizedBox(
              height: 32,
            ),
            CustomButton(
                onPress: () {
                  print(area);
                  if (board != null && (area?.isNotEmpty ?? false)) {
                    widget.onAdd((board!, area!));

                    NavigationService.navigatorKey.currentState!.pop(
                      context,
                    );
                  }
                },
                text: "إضافة")
          ],
        ),
      ),
    );
  }
}
