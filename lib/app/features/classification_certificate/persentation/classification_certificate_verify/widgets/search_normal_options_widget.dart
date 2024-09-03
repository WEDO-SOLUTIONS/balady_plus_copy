import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class SearchNormalOptionsWidget extends StatelessWidget {
  final String title;
  final String description;
  final int value;
  final int groupValue;
  final GestureTapCallback onTap;

  const SearchNormalOptionsWidget({
    super.key,
    required this.title,
    required this.description,
    required this.value,
    required this.groupValue,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            width: 1,
            color: Theme.of(context).primaryColor,
          )),
      elevation: 0,
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 6),
            child: RadioListTile(
              value: value,
              groupValue: groupValue,
              onChanged: (val) {},
              title: Text(title.tr()),
              subtitle: Text(description.tr()),
            ),
          ),
        ),
      ),
    );
  }
}
