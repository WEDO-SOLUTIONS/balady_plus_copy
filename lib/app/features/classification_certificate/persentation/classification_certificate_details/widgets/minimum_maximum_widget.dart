import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class MinimumMaximumWidget extends StatelessWidget {
  final String title;
  final String value;

  const MinimumMaximumWidget({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$value ${"saudi_riyal".tr()}",
          style: Theme.of(context).textTheme.labelSmall!.copyWith(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          title.tr(),
          style: Theme.of(context).textTheme.labelSmall!.copyWith(
            color: const Color(0xff999999),
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
