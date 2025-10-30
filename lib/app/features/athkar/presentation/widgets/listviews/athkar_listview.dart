import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/athkar/athkar_exports.dart'
    show AthkarCard, StaticAthkarData;
import 'package:flutter/material.dart';

class AthkarListView extends StatelessWidget {
  AthkarListView({
    super.key,
  });

  final List athkarList = StaticAthkarData.athkarCategories;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 24,
      ),
      itemCount:
          CommonFunctions.isAppAR ? athkarList.length : athkarList.length - 2,
      itemBuilder: (context, index) {
        return AthkarCard(athkarCategory: athkarList[index]);
      },
    );
  }
}
