import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class TitleValueWidget extends StatelessWidget {
  final String title;
  final String value;

  const TitleValueWidget({
    super.key,
    required this.title,
    required this.value,
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
              child: Text(
                title.tr(),
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: const Color(0xff52525B),
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
            const SizedBox(width: 4),
            Flexible(
              flex: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    fit: FlexFit.loose,
                    child: Text(
                      value,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w700,
                          ),
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
