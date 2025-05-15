import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/pdf/core/image_path.dart';

import '../../../home/custom_app_bar.dart';
import 'conditions_model.dart';
import 'container_requir.dart';
import 'requir_item.dart';

class Requirements extends StatefulWidget {
  const Requirements({super.key});

  @override
  State<Requirements> createState() => _RequirementsState();
}

class _RequirementsState extends State<Requirements> {
  List<ConditionsModel> data = [];

  Future<void> readdata() async {
    if (data.isNotEmpty) return;
    String ad = await rootBundle
        .loadString("assets/compliance_pdf/text/conditions.json");
    var A = json.decode(ad);
    print(A);
    {
      List<ConditionsModel>? model = A != null
          ? List<ConditionsModel>.from(A.map((x) => ConditionsModel.fromMap(x)))
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
        name: 'اشتراطات شهادة امتثال المباني',
        listicon: ImagePath.frame,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'اشتراطات شهادة امتثال المباني',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Color(0xFF145E75),
                    fontSize: 17,
                    fontFamily: 'packages/balady_uikit/Frutiger',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Text(
                  'يشترط لإصدار شهادة امتثال المبنى وفق هذا الدليل، خلوه من المخالفات الآتية:',
                  style: TextStyle(
                    color: Color(0xFF52525B),
                    fontSize: 14,
                    fontFamily: 'packages/balady_uikit/Frutiger',
                    fontWeight: FontWeight.w700,
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
                    return RequirementsItem(
                      desc: data[index].desc,
                      image: data[index].photo,
                    );
                  },
                ),
                const ContainerRequir(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
