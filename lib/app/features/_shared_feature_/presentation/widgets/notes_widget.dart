import 'package:flutter/material.dart';

import '../../../../core/utils/utils_exports.dart';
import '../../shared_feature_exports.dart';

class NotesWidget extends StatelessWidget {
  const NotesWidget({
    super.key, required this.notes,
  });

  final List<String> notes;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            color: AppColor.primary50Light,
          ),
          child: ListView.separated(
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemCount: notes.length,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (_, index) =>  Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 6),
                  child: Icon(Icons.circle,
                      size: 5, color: AppColor.primary500Light),
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: CustomTextWidget(
                    notes[index],
                    textAlign: TextAlign.start,
                    fontSize: 14,
                    maxLines: null,
                    height: 1.2,
                    fontColor: AppColor.primary500Light,
                    fontWeight: AppFontWeight.semiBold,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
