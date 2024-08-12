import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/widgets.dart';
import 'package:mapness/widgets/feedback/feedback_label.dart';

class FeedbackChipsData {
  final String title;
  final IconData leadingIcon;

  const FeedbackChipsData({required this.title, required this.leadingIcon});
}

class FeedbackChips extends StatelessWidget {
  final List<FeedbackChipsData> data;
  final void Function(int?) onIndexChanged;
  final int? selectedIndex;
  const FeedbackChips({
    required this.onIndexChanged,
    required this.data,
    super.key,
    this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FeedbackLabel(text: 'What’s happened'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: data.indexed
                .map((e) => Chips(
                      title: e.$2.title,
                      isSelected: selectedIndex == e.$1,
                      leadingIcon: ChipIconData(
                        e.$2.leadingIcon,
                      ),
                      onTap: () {
                        onIndexChanged(e.$1);
                      },
                      style: ChipsStyle.whiteBackground,
                    ))
                .toList(),
            // [
            //   Chips(
            //     title: 'There is no such company here',
            //     isSelected: selectedIndex == 0,
            //     leadingIcon: ChipIconData(
            //       GeneralIcons.clearCircle,
            //     ),
            //     onTap: () {
            //       onIndexChanged(0);
            //     },
            //     style: ChipsStyle.whiteBackground,
            //   ),
            //   Chips(
            //     title: 'Temporarily closed',
            //     isSelected: selectedIndex == 1,
            //     leadingIcon: ChipIconData(
            //       GeneralIcons.timeQuarter,
            //     ),
            //     onTap: () {
            //       onIndexChanged(1);
            //     },
            //     style: ChipsStyle.whiteBackground,
            //   ),
            //   // ChipRowContent(
            //   //   label: 'Temporarily closed',
            //   //   leadingIcon: ChipIconData(
            //   //     GeneralIcons.timeQuarter,
            //   ),
            // ),
            // ChipRowContent(
            //   label: 'Company has moved',
            //   leadingIcon: ChipIconData(
            //     GeneralIcons.pin,
            //   ),
            // ),
            // ChipRowContent(
            //   label: 'Other',
            //   leadingIcon: ChipIconData(
            //     GeneralIcons.questionCircle,
            //   ),
            // )
            // ],
          )
        ],
      );
}
