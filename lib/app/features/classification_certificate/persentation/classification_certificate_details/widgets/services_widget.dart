import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import 'minimum_maximum_widget.dart';

class ServicesWidget extends StatelessWidget {
  final String title;
  final String description;
  final String minimum;
  final String maximum;

  const ServicesWidget({
    super.key,
    required this.title,
    required this.description,
    required this.minimum,
    required this.maximum,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xffE6EFEF),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 12,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title.tr(),
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: const Color(0xff52525B),
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  Text(
                    description.tr(),
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                      color: const Color(0xff999999),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MinimumMaximumWidget(title: 'minimum', value: minimum),
                const SizedBox(height: 2),
                MinimumMaximumWidget(title: 'maximum', value: maximum),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
