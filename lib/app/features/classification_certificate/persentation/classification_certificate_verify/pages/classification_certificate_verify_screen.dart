import 'package:balady_plus/app/features/classification_certificate/persentation/classification_certificate_verify/bloc/classification_certificate_verify_bloc.dart';
import 'package:balady_plus/app/features/classification_certificate/persentation/classification_certificate_verify/utility/enums.dart';
import 'package:balady_plus/app/features/classification_certificate/persentation/classification_certificate_verify/widgets/normal_search/normal_search_verified_by_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../_shared_feature_/presentation/widgets/default_appbar_widget.dart';
import '../widgets/action_button_widget.dart';
import '../widgets/advanced_search_widget.dart';
import '../widgets/normal_search/normal_search_list_widget.dart';
import '../widgets/search_type_widget.dart';

class ClassificationCertificateVerifyScreen extends StatelessWidget {
  const ClassificationCertificateVerifyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return ClassificationCertificateVerifyBloc();
      },
      child: Scaffold(
        backgroundColor: AppColor.scaffoldBackground,
        resizeToAvoidBottomInset: true,
        appBar: DefaultAppBarWidget(
          title: "back".tr(),
          showBack: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "search_method".tr(),
                style: Theme.of(context).textTheme.titleLarge!.copyWith(),
              ),
              const SizedBox(height: 16),

              // for select type search of screen
              BlocBuilder<ClassificationCertificateVerifyBloc,
                  ClassificationCertificateVerifyState>(
                buildWhen: (state, stateNew) {
                  return stateNew
                          is NormalSearchClassificationCertificateState ||
                      stateNew is AdvancedSearchState ||
                      stateNew is AdvancedMethodNotWorkingState ||
                      stateNew is AdvancedSearchLoadingState;
                },
                builder: (contextBloc, state) {
                  return Card(
                    color: Colors.grey.shade200,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: SearchTypeWidget(
                            typeMethod: SearchMethod.search,
                            selectedTypeMethod: state.typeMethod,
                          ),
                        ),
                        Expanded(
                          child: SearchTypeWidget(
                            typeMethod: SearchMethod.advancedSearch,
                            selectedTypeMethod: state.typeMethod,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: [
                    BlocBuilder<ClassificationCertificateVerifyBloc,
                        ClassificationCertificateVerifyState>(
                      builder: (contextBloc, state) {
                        Widget? child;
                        if (state is NormalSearchClassificationCertificateState) {
                          child = NormalSearchListWidget(state: state);
                        }
                        if (state
                        is NormalSearchVerifiedByClassificationCertificateState) {
                          child = NormalSearchVerifiedByWidget(state: state);
                        }
                        if (state is AdvancedSearchState) {
                          child = AdvancedSearchWidget(
                            key: Key(state.toString()),
                            state: state,
                          );
                        }
                        if (state is AdvancedSearchLoadingState) {
                          return  Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              children: [
                                const Center(child: CircularProgressIndicator()),
                                const SizedBox(height: 16),
                                Text("please_wait".tr()),
                              ],
                            ),
                          );
                        }
                        if (state is AdvancedMethodNotWorkingState) {
                          return  Column(
                            children: [
                              Text(
                                "the_advanced_search_not_working_try_again_later".tr(),
                              ),
                            ],
                          );
                        }
                        return Form(
                          key: contextBloc
                              .read<ClassificationCertificateVerifyBloc>()
                              .formKey,
                          child: child ?? const SizedBox(),
                        );
                      },
                    )
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const ActionButtonWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
