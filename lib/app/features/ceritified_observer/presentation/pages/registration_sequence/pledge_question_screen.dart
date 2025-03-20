import 'package:app_popup_menu/app_popup_menu.dart';
import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import 'package:balady_plus/app/features/ceritified_observer/domain/lookups.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../blocs/choose_muncipality_bloc.dart';

class PledgeQuestionScreen extends StatefulWidget {
  const PledgeQuestionScreen({Key? key}) : super(key: key);

  @override
  State<PledgeQuestionScreen> createState() => _PledgeQuestionScreenState();
}

class _PledgeQuestionScreenState extends State<PledgeQuestionScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChooseMuncipalityBloc, CertifiedObserverState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is ChooseMuncipalityState) {
          return Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: PledgeQuestion.values.map(
                        (pledge) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(width: double.maxFinite),
                              Text("${pledge.name}_title".tr()),
                              Text("${pledge.name}_description".tr()),
                            ],
                          );
                        },
                      ).toList(),
                    ),
                  ),
                ),
              ),

              //// Button Action

              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(36),
                    topRight: Radius.circular(36),
                  ),
                  color: Colors.white,
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 26),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: state.requestData?.pledgeQuestion ?? false,
                          onChanged: (value) {
                            context.read<ChooseMuncipalityBloc>().add(
                                  SetRequestDataEvent(
                                    dataModel: state.requestData!.copyWith(
                                      pledgeQuestion: value,
                                    ),
                                  ),
                                );
                          },
                        ),
                        Text(
                          "data".tr(),
                          style: const TextStyle(
                            color: Color(0xFF447F91),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    CustomElevatedButtonWidget(
                      btnColor: AppColor.primary800Light,
                      textStyle: AppStyle.elevatedButtonStyle.copyWith(
                        color: AppColor.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                      btnHeight: 56,
                      text: "next".tr(),
                      onPressed: () {
                        if (state.requestData?.pledgeQuestion ?? false) {
                          context
                              .read<ChooseMuncipalityBloc>()
                              .add(const GoToNextPageEvent());
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
