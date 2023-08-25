import 'package:balady_plus/app/features/athkar/athkar_exports.dart'
    show AthkarAppBar, AthkarEntitiesListView, AthkarEntitiesParams;
import 'package:flutter/material.dart';

class AthkarEntities extends StatefulWidget {
  const AthkarEntities({super.key});

  @override
  State<AthkarEntities> createState() => _AthkarEntitiesState();
}

class _AthkarEntitiesState extends State<AthkarEntities> {
  @override
  Widget build(BuildContext context) {
    AthkarEntitiesParams params =
        ModalRoute.of(context)!.settings.arguments as AthkarEntitiesParams;
    return Scaffold(
      // backgroundColor: AppColor.scaffoldBackground,
      appBar: AthkarAppBar(title: params.title),
      body:
          AthkarEntitiesListView(athkarEntitiesList: params.athkarEntitiesList),
    );
  }
}
