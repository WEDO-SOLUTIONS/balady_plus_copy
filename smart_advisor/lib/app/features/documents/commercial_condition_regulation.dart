import 'dart:convert';

import 'package:smart_advisor/app/features/documents/models/custom_table_type1_model.dart';

import '/app/core/utils/constants/app_colors.dart';
import '/app/core/utils/constants/app_style.dart';
import '/app/features/_shared_feature_/presentation/widgets/custom_widgets/custom_table_type1_expanded.dart';
import '/app/features/shared_features/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'widgets/document_header.dart';

class CommercialConditionRegulation extends StatefulWidget {
  const CommercialConditionRegulation({super.key});

  @override
  State<CommercialConditionRegulation> createState() =>
      _CommercialConditionRegulationState();
}

class _CommercialConditionRegulationState
    extends State<CommercialConditionRegulation> {
  bool isViewDetail = false;
  List<CustomTableTypeModel> _requirements = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadRequirements();
  }

  Future<void> loadRequirements() async {
    final String response = await rootBundle.loadString('assets/files/12.json');
    final data = await json.decode(response);

    List<CustomTableTypeModel> loadedRequirements = [];
    for (var item in data['requirements']) {
      loadedRequirements.add(CustomTableTypeModel.fromJson(item));
    }

    setState(() {
      _requirements = loadedRequirements;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          DocumentHeader(
            title: 'اشترطات اللوحات التجارية ',
          ),
          Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 20),
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _requirements.length,
                  itemBuilder: (ctx, index) {
                    return CustomTableType1Expanded(
                      item: _requirements[index],
                    );
                  })),
        ],
      ),
    );
  }
}
