import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/widgets.dart';
import 'package:mapness/widgets/feedback/feedback_label.dart';

class FeedbackChipsData {
  final String title;
  final IconData? leadingIcon;

  const FeedbackChipsData({
    required this.title,
    required this.leadingIcon,
  });
}

class FeedbackChips extends StatelessWidget {
  final String label;
  final List<FeedbackChipsData> data;
  final void Function(int?) onIndexChanged;
  final int? selectedIndex;
  const FeedbackChips({
    required this.label,
    required this.onIndexChanged,
    required this.data,
    super.key,
    this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FeedbackLabel(text: label),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: data.indexed
                .map((e) => Chips(
                      title: e.$2.title,
                      isSelected: selectedIndex == e.$1,
                      leadingIcon: e.$2.leadingIcon != null
                          ? ChipIconData(
                              e.$2.leadingIcon!,
                            )
                          : null,
                      onTap: () {
                        onIndexChanged(e.$1);
                      },
                      style: ChipsStyle.whiteBackground,
                    ))
                .toList(),
          )
        ],
      );
}
