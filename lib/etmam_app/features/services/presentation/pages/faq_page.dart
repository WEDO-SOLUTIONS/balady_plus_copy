import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/default_appbar_widget.dart';
import 'package:balady_plus/etmam_app/core/services/services_exports.dart'
    show AppEvents;
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show CustomAppBar, Faq;
import 'package:flutter/material.dart';

import '../../../../core/utils/utils_exports.dart'
    show AppColor, CommonFunctions, trans;
import '../../../_shared_feature_/shared/presentation/widgets/custom_expansion_widget.dart';

class FaqPage extends StatefulWidget {
  const FaqPage({Key? key}) : super(key: key);

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
    List<Faq> faqList = ModalRoute.of(context)!.settings.arguments as List<Faq>;
    return Scaffold(
        appBar: DefaultAppBarWidget(
          title: trans('service_faq'),
        ),
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          decoration: const BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: faqList.length,
            itemBuilder: (ctx, index) {
              return ExpansionItemWidget(
                title: faqList[index].question ?? "",
                subTitle: faqList[index].answer ?? "",
                isExpanded: index == 0,
                containerColor: AppColor.white,
              );
            },
          ),
        ));
  }
}
