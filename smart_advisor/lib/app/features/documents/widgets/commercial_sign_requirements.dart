import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:smart_advisor/app/features/documents/models/commercial_sign_requirements_model.dart';
import '/app/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CommercialSignRequirements extends StatefulWidget {
  CommercialSignRequirements({super.key});

  @override
  State<CommercialSignRequirements> createState() =>
      _CommercialSignRequirementsState();
}

class _CommercialSignRequirementsState
    extends State<CommercialSignRequirements> {
  List<CommercialSignRequirementsModel> _Commercialrequirements = [];

  @override
  void initState() {
    super.initState();
    loadRequirements();
  }

  Future<void> loadRequirements() async {
    final String response = await rootBundle
        .loadString('packages/smart_advisor/smart_advisor_assets/files/1.json');
    final data = await json.decode(response);

    List<CommercialSignRequirementsModel> loadedRequirements = [];
    for (var item in data['requirements']) {
      loadedRequirements.add(CommercialSignRequirementsModel.fromJson(item));
      print("here");
    }

    setState(() {
      _Commercialrequirements = loadedRequirements;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColor.statusAccentColor),
          onPressed: () {
            // Handle back button action
          },
        ),
        title: Text(
          'الملحق',
          style: AppStyle.calloutBoldStyle
              .copyWith(color: AppColor.textPrimaryColor),
        ),
        centerTitle: true,
        actions: [SvgPicture.asset('assets/images/svg_icon/PDFicone.svg')],
      ),
      body: SingleChildScrollView(
        // Make the whole page scrollable
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'اشتراطات اللوحات التجارية',
              style: AppStyle.heading1BoldStyle
                  .copyWith(color: AppColor.textPrimaryColor),
            ),
            Text(
              'سبتمبر ٢٠٢٠',
              style:
                  AppStyle.heading1BoldStyle.copyWith(color: AppColor.primary),
            ),
            const SizedBox(height: 450),
            Image.asset(
                'packages/smart_advisor/smart_advisor_assets/images/commercial.png'),
            ListView.builder(
              shrinkWrap:
                  true, // Important to avoid issues with nested ListView
              physics:
                  NeverScrollableScrollPhysics(), // Disable inner scrolling
              itemCount: _Commercialrequirements.length,
              itemBuilder: (context, i) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("أولا"),
                    ListView.builder(
                      shrinkWrap: true, // Important for nested lists
                      physics:
                          NeverScrollableScrollPhysics(), // Disable inner scrolling
                      itemCount: _Commercialrequirements[i].requirements.length,
                      itemBuilder: (ctx, j) {
                        return Text(_Commercialrequirements[i]
                            .requirements[j]
                            .description);
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
