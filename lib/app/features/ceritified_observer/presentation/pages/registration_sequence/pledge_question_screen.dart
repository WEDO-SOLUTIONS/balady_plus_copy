import 'package:app_popup_menu/app_popup_menu.dart';
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
                              const SizedBox(
                                width: double.maxFinite,
                              ),
                              Text(
                                "${pledge.name}_title".tr(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "${pledge.name}_description".tr(),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF292D32),
                                ),
                              ),
                              const SizedBox(height: 12),
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
                        Flexible(
                          fit: FlexFit.tight,
                          child: Text(
                            "pledge_certified_observer".tr(),
                            style: const TextStyle(
                              color: Color(0xFF447F91),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),

                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: state.requestData?.pledgeQuestion ?? false
                            ? () {
                                context
                                    .read<ChooseMuncipalityBloc>()
                                    .add(const GoToNextPageEvent());
                              }
                            : null,
                        child: Text("next".tr()),
                      ),
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
