import 'package:balady_plus/app/features/athkar/athkar_exports.dart'
    show AthkarCard, AthkarEntity, AthkarEntityCard;
import 'package:flutter/material.dart';

class AthkarEntitiesListView extends StatelessWidget {
  const AthkarEntitiesListView({
    required this.athkarEntitiesList,
    super.key,
  });
  final List<AthkarEntity> athkarEntitiesList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 24,
      ),
      itemCount: athkarEntitiesList.length,
      itemBuilder: (context, index) {
        return AthkarEntityCard(
          athkarEntity: athkarEntitiesList[index],
          pageNumber: index,
          athkarEntitiesList: athkarEntitiesList,
        );
      },
    );
  }
}
