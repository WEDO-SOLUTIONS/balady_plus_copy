import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/under_testing/custom_expansion_panel_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/details_header.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../_shared_feature_/presentation/under_testing/custom_enhanced_expansion_panel_widget.dart';
import '../../../_shared_feature_/presentation/widgets/search_text_field_widget.dart';
import '../blocs/qa_bloc.dart';
import '../widgets/qa_page_header.dart';

class QAPage extends StatefulWidget {
  const QAPage({super.key});

  @override
  State<QAPage> createState() => _QAPageState();
}

class _QAPageState extends State<QAPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QABloc(),
      child: BlocConsumer<QABloc, QAState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return Scaffold(
              appBar: QADetailsHeader(
                title: "الاسئلة الشائعة",
              ),
              body: Container(
                  padding: EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SearchTextFieldWidget(
                          containerHeight: 52,
                          hintText: "search".tr(),
                          onTextChanged: (String text) {},
                          onSubmitSearch: (String val) {},
                        ),
                        const CustomVerticalSpace(height: 32),
                        ListView.builder(
                            itemCount: state.list?.length ?? 0,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (ctx, index) {
                              return Column(
                                children: [
                                  CustomEnhancedExpansionPanelWidget(
                                    title: state.list?[index].question ?? "",
                                    leadingWidth: 0,
                                    leading: null,
                                    children: [
                                      CustomTextWidget(
                                        state.list?[index].answer ?? "",
                                        fontColor: Color(0xFF52525B),
                                        fontWeight: AppFontWeight.bold,
                                        fontSize: 12,
                                        height: 1.6,
                                        maxLines: 100,
                                      )
                                    ],
                                  ),
                                  CustomVerticalSpace(height: 16)
                                ],
                              );
                            }),
                      ],
                    ),
                  )));
        },
      ),
    );
  }
}
