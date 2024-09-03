import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class SearchTypeWidget extends StatelessWidget {
  final String title;
  final bool isSelected;
  final GestureTapCallback onTap;

  const SearchTypeWidget({
    super.key,
    required this.title,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.zero,
      elevation: 0,
      color: isSelected ? Theme.of(context).primaryColor : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title.tr(),
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: isSelected ? Colors.white : Colors.grey ,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
