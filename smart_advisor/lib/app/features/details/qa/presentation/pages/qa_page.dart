import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:smart_advisor/app/core/utils/constants/app_style.dart';

import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_enhanced_expansion_panel_widget.dart';
import '../blocs/qa_bloc.dart';

class QAPage extends StatefulWidget {
  const QAPage({super.key});

  @override
  State<QAPage> createState() => _QAPageState();
}

class _QAPageState extends State<QAPage> {
  @override
  void initState() {
    super.initState();
    //   CommonFunctions.sendEventToAnalytics(AppEvents.faq);

    // CommonFunctions.sendUXCamEvent(UXCamEvents.complianceFAQ);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QABloc(),
      child: BlocConsumer<QABloc, QAState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return Container(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    /* SearchTextFieldWidget(
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
                        ),*/
                    Container(
                      decoration: ShapeDecoration(
                          color: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          )),
                      //  padding: const EdgeInsets.all(17),
                      child: MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        child: ListView.builder(
                            itemCount: state.filtered?.length ?? 0,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (ctx, index) {
                              return Column(
                                children: [
                                  CustomEnhancedExpansionPanelWidget(
                                    title:
                                        state.filtered?[index].question ?? "",
                                    leadingWidth: 0,
                                    leading: null,
                                    children: [
                                      if (state.filtered?[index].answer == "1")
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                  text:
                                                      'يلزم للحصول على شهادة الامتثال تحقيق معايير ( تصميم المبنى، الموقع العام، التشوه البصري) وللتعرّف على مزيد من المعلومات يمكنكم الاطلاع على',
                                                  style: TextStyle(
                                                    color: AppColor
                                                        .statusAccentColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                    height: 1.6,
                                                  )),
                                              TextSpan(
                                                text:
                                                    ' دليل إجراءات شهادة امتثال المباني  ',
                                                style: TextStyle(
                                                  color:
                                                      AppColor.textPrimaryColor,
                                                  fontWeight: FontWeight.bold,
                                                  decoration:
                                                      TextDecoration.none,
                                                ),
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () {
                                                        /*  Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder: (context) =>
                                                                    const CompliancePDFHomePage(),
                                                              ),
                                                            );
                        */
                                                      },
                                              ),
                                              const TextSpan(text: '.'),
                                            ],
                                          ),
                                        ),
                                      if (state.filtered?[index].answer != "1")
                                        Text(
                                          state.filtered?[index].answer ?? "",
                                          style: AppStyle.textRegularRomanStyle
                                              .copyWith(
                                                  color: AppColor
                                                      .statusAccentColor),
                                          /* fontColor: Color(0xFF52525B),
                                              fontWeight: AppFontWeight.bold,
                                              fontSize: 12,
                                              height: 1.6,*/
                                          maxLines: 100,
                                        )
                                    ],
                                  ),
                                  const SizedBox(height: 16)
                                ],
                              );
                            }),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ));
        },
      ),
    );
  }
}
