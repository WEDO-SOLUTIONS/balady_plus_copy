import 'dart:convert';
import 'package:balady_plus/app/features/create_compliance/presentation/pdf/core/image_path.dart';

import '../../../home/custom_app_bar.dart';
import '../terms/term_model.dart';
import '../terms/terms_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TermsAndDefinitions extends StatefulWidget {
  const TermsAndDefinitions({super.key});

  @override
  State<TermsAndDefinitions> createState() => _TermsAndDefinitionsState();
}

class _TermsAndDefinitionsState extends State<TermsAndDefinitions> {
  List<TermModel> data = [];

  Future<void> readdata() async {
    if (data.isNotEmpty) return;
    String qa =
        await rootBundle.loadString("assets/compliance_pdf/text/defi.json");
    var r = json.decode(qa);
    print(r);
    {
      List<TermModel>? model = r != null
          ? List<TermModel>.from(r.map((x) => TermModel.fromMap(x)))
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
        name: 'المصطلحات والتعريفات',
        listicon: ImagePath.frame,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'المصطلحات والتعريفات',
                  style: TextStyle(
                    color: Color(0xFF145E75),
                    fontSize: 17,
                    fontFamily: 'packages/balady_uikit/Frutiger',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Text(
                  'يقصد بالألفاظ والمصطلحات الآتية - أينما وردت في هذه الدليل - المعاني المبينة أمام كل منها، ما لم يقتض السياق غير ذلك',
                  style: TextStyle(
                    color: Color(0xFF52525B),
                    fontSize: 14,
                    fontFamily: 'packages/balady_uikit/Frutiger',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: data.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return TermsItem(
                        name: data[index].name, desc: data[index].desc);
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
