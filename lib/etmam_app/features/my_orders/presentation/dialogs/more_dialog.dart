import 'package:balady_plus/etmam_app/features/my_orders/domain/entities/order_item.dart';
import 'package:flutter/material.dart' hide Action;

import '../../../../core/utils/utils_exports.dart' show AppColor;
import '../../my_orders_exports.dart' show OrderMoreButton;

class MoreDialog extends StatelessWidget {
  final String orderId;
  final List<Action> actions;
  final Function? refresh;
  final Function? onSelect;

  const MoreDialog(
      {Key? key,
      required this.actions,
      required this.orderId,
      this.refresh,
      this.onSelect})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
            shrinkWrap: true,
            itemCount: actions.length,
            itemBuilder: (ctx, index) {
              return OrderMoreButton(
                text: actions[index].name ?? "",
                icon: actions[index].action?.icon ?? "",
                btnColor: actions[index].action?.color ?? AppColor.black,
                btnPressed: () {
                  if (onSelect != null) onSelect!(actions[index].action);
                },
              );
            })
      ],
    );
  }
}
