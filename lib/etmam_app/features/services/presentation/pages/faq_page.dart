import 'package:balady_plus/etmam_app/core/services/services_exports.dart'
    show AppEvents;
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show CustomAppBar, Faq;
import 'package:flutter/material.dart';

import '../../../../core/utils/utils_exports.dart'
    show AppColor, CommonFunctions, trans;
import '../../../_shared_feature_/shared/presentation/widgets/custom_expansion_widget.dart';

class FaqPage extends StatefulWidget {
  final List<Faq> faqList;

  const FaqPage({Key? key, required this.faqList}) : super(key: key);

  @override
  State<FaqPage> createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  @override
  void initState() {
    super.initState();
    //CommonFunctions.sendEventToAnalytics(AppEvents.FaqPage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: trans('service_faq'),
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: widget.faqList.length,
          itemBuilder: (ctx, index) {
            return ExpansionItemWidget(
              title: widget.faqList[index].question ?? "",
              subTitle: widget.faqList[index].answer ?? "",
              isExpanded: index == 0,
              containerColor: AppColor.white,
            );
          },
        ));
  }
}
