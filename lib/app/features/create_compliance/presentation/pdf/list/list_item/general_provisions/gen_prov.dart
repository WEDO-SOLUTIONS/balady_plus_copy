import 'dart:convert';
import 'package:balady_plus/app/features/create_compliance/presentation/pdf/core/image_path.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/pdf/list/list_item/general_provisions/provisions_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../home/custom_app_bar.dart';
import '../requir_item/item.dart';

class GeneralProvisions extends StatefulWidget {
  const GeneralProvisions({super.key});

  @override
  State<GeneralProvisions> createState() => _GeneralProvisionsState();
}

class _GeneralProvisionsState extends State<GeneralProvisions> {
  List<ProvisionsModel> data = [];

  Future<void> readdata() async {
    if (data.isNotEmpty) return;

    String qa = await rootBundle
        .loadString("assets/compliance_pdf/text/provisions.json");
    var r = json.decode(qa);
    print(r);
    {
      List<ProvisionsModel>? model = r != null
          ? List<ProvisionsModel>.from(r.map((x) => ProvisionsModel.fromMap(x)))
          : null;
      data = model ?? [];
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    readdata();
    return Scaffold(
      appBar: const CustomAppBar(
        icon: ImagePath.arrowright,
        name: 'الأحكام العامة',
        listicon: ImagePath.frame,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'أحكام عامة',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Color(0xFF145E75),
                    fontSize: 17,
                    fontFamily: 'packages/balady_uikit/Frutiger',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: data.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Item(desc: data[index].desc);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
