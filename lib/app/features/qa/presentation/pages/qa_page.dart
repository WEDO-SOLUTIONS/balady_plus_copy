import 'package:balady_plus/app/core/utils/app_analytics_events.dart';
import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/under_testing/custom_expansion_panel_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/details_header.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/constants/ux_cam_events.dart';
import '../../../_shared_feature_/presentation/under_testing/custom_enhanced_expansion_panel_widget.dart';
import '../../../_shared_feature_/presentation/widgets/search_text_field_widget.dart';
import '../../../create_compliance/presentation/pdf/home/home.dart';
import '../blocs/qa_bloc.dart';
import '../widgets/qa_ask_more.dart';
import '../widgets/qa_page_header.dart';

class QAPage extends StatefulWidget {

   const QAPage({super.key});

  @override
  State<QAPage> createState() => _QAPageState();
}

class _QAPageState extends State<QAPage> {
  @override
  void initState() {
    super.initState();
    CommonFunctions.sendEventToAnalytics(AppEvents.faq);

    CommonFunctions.sendUXCamEvent(UXCamEvents.complianceFAQ);
  }

  @override
  Widget build(BuildContext context) {


    final String serviceId =
    ModalRoute.of(context)!.settings.arguments as String;

    return BlocProvider(
      create: (context) => QABloc(serviceId),
      child: BlocConsumer<QABloc, QAState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return Scaffold(
              appBar: QADetailsHeader(
                title: "faq".tr(),
              ),
              body: Container(
                  padding: EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SearchTextFieldWidget(
                          containerHeight: 52,
                          hintText: "search".tr(),
                          onTextChanged: (String text) {
                            context
                                .read<QABloc>()
                                .add(GetQADatSearchedaEvent(text: text));
                          },
                          onSubmitSearch: (String val) {
                            context
                                .read<QABloc>()
                                .add(GetQADatSearchedaEvent(text: val));
                          },
                        ),
                        const CustomVerticalSpace(height: 32),
                        Container(
                          decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              )),
                          padding: const EdgeInsets.all(17),
                          child: ListView.builder(
                              itemCount: state.filtered?.length ?? 0,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (ctx, index) {
                                return Column(
                                  children: [
                                    CustomEnhancedExpansionPanelWidget(
                                      title:
                                          state.filtered?[index].title ?? "",
                                      leadingWidth: 0,
                                      leading: null,
                                      children: [
                                        if (state.filtered?[index].fieldFaqAnswer ==
                                            "1")
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                    text:
                                                        'يلزم للحصول على شهادة الامتثال تحقيق معايير ( تصميم المبنى، الموقع العام، التشوه البصري) وللتعرّف على مزيد من المعلومات يمكنكم الاطلاع على',
                                                    style: TextStyle(
                                                      color: Color(0xFF52525B),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12,
                                                      height: 1.6,
                                                    )),
                                                TextSpan(
                                                  text:
                                                      ' دليل إجراءات شهادة امتثال المباني  ',
                                                  style: TextStyle(
                                                    color: AppColor
                                                        .primary900Light,
                                                    fontWeight: FontWeight.bold,
                                                    decoration:
                                                        TextDecoration.none,
                                                  ),
                                                  recognizer:
                                                      TapGestureRecognizer()
                                                        ..onTap = () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  const CompliancePDFHomePage(),
                                                            ),
                                                          );

                                                          /*   CommonFunctions
                                                              .externalLaunch(
                                                                  "https://momrah.gov.sa/sites/default/files/2023-03/dlyl-ajraat-shhadt-amtthal-almbany000.pdf");*/
                                                        },
                                                ),
                                                TextSpan(text: '.'),
                                              ],
                                            ),
                                          ),
                                        if (state.filtered?[index].fieldFaqAnswer !=
                                            "1")

                                          Linkify(
                                            onOpen: (link) => CommonFunctions.openBaladyWebView(link.url),
                                            text: state.filtered?[index].fieldFaqAnswer ?? "",
                                            softWrap: true,
                                            textAlign: TextAlign.start,
                                            style: AppStyle.textFieldTitleTextStyle.copyWith(
                                              color: AppColor.blackModern700Light,
                                            ),
                                          ),
                                          // Linkify(
                                          //   state.filtered?[index].fieldFaqAnswer ?? "",
                                          //   fontColor: Color(0xFF52525B),
                                          //   fontWeight: AppFontWeight.bold,
                                          //   fontSize: 12,
                                          //   height: 1.6,
                                          //   maxLines: 100,
                                          // )
                                      ],
                                    ),
                                    CustomVerticalSpace(height: 16)
                                  ],
                                );
                              }),
                        ),
                        const CustomVerticalSpace(height: 32),
                        QAAskMore(),
                      ],
                    ),
                  )));
        },
      ),
    );
  }
}
