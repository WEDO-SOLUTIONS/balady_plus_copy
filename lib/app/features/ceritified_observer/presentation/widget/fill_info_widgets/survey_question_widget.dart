import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class SurveyQuestionWidget extends StatelessWidget {
  final String name;
  final bool? groupValue;
  final void Function(dynamic value) onChange;

  const SurveyQuestionWidget({
    super.key,
    required this.name,
    required this.groupValue,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name.tr()),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    if (groupValue != true) {
                      onChange(true);
                    }
                  },
                  child: Card(
                    color: Colors.grey.shade100,
                    child: Row(
                      children: [
                        Radio(
                          value: true,
                          groupValue: groupValue,
                          onChanged: (value) {
                            onChange(value);
                          },
                        ),
                        Text("yes".tr()),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                  child: InkWell(
                onTap: () {
                  if (groupValue != false) {
                    onChange(false);
                  }
                },
                child: Card(
                  color: Colors.grey.shade100,
                  child: Row(
                    children: [
                      Radio(
                        value: false,
                        groupValue: groupValue,
                        onChanged: (value) {
                          onChange(value);
                        },
                      ),
                      Text("no".tr()),
                    ],
                  ),
                ),
              ))
            ],
          )
        ],
      ),
    );
  }
}
