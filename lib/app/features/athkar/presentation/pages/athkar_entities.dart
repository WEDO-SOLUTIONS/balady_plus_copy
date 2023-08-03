import 'package:balady_plus/app/features/athkar/athkar_exports.dart'
    show AthkarAppBar, AthkarEntitiesListView, AthkarEntitiesParams;
import 'package:flutter/material.dart';

class AthkarEntities extends StatelessWidget {
  const AthkarEntities({super.key, required this.params});

  final AthkarEntitiesParams params;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColor.scaffoldBackground,
      appBar: AthkarAppBar(title: params.title),
      body:
          AthkarEntitiesListView(athkarEntitiesList: params.athkarEntitiesList),
    );
  }
}
