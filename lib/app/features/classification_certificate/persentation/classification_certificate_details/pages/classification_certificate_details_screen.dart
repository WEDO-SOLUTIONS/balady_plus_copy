import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/reload_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/features/classification_certificate/persentation/classification_certificate_details/bloc/classification_certificate_details_state.dart';
import 'package:balady_plus/app/features/classification_certificate/persentation/classification_certificate_details/widgets/attach_button_widgt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../data/model/details/details_request_model.dart';
import '../bloc/classification_certificate_details_cubit.dart';
import '../widgets/details_data_widget.dart';

class ClassificationCertificateDetailsScreen extends StatelessWidget {
  const ClassificationCertificateDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return BlocProvider<ClassificationCertificateDetailsCubit>(
      create: (_) => ClassificationCertificateDetailsCubit(
        detailsRequestModel: DetailsRequestModel.fromJson(data),
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: DefaultAppBarWidget(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 16),
          child: Column(
            children: [
              SvgPicture.asset(IconPath.documentCopy),
              Text(
                "certificate_verification_result".tr(),
                style: Theme.of(context).textTheme.titleLarge!.copyWith(),
              ),
              Expanded(
                child: BlocBuilder<ClassificationCertificateDetailsCubit,
                    ClassificationCertificateDetailsState>(
                  builder: (contextCubit, state) {
                    if (state is LoadingDetailsClassificationCertificateState) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is FieldDetailsClassificationCertificateState) {
                      return ReloadWidget(
                        errorMessage: state.errorMessage,
                        onTab: () {
                          ClassificationCertificateDetailsCubit cubit =
                              contextCubit.read<
                                  ClassificationCertificateDetailsCubit>();
                          cubit.getDetailsClassificationCertificate(
                            detailsRequestModel: cubit.detailsRequestModel,
                          );
                        },
                      );
                    }
                    if (state is SuccessDetailsClassificationCertificateState) {
                      return Column(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              child: DetailsDataWidget(
                                classificationCertificateDetails:
                                    state.classificationCertificateDetails,
                              ),
                            ),
                          ),

                          AttachedButtonWidget(state: state),
                          ////////////////////////////////////////////////////
                          const SizedBox(height: 16),
                          state.classificationCertificateDetails
                                      .classificationType ==
                                  "Classification of Engineer"
                              ? ElevatedButton(
                                  onPressed: () {
                                    launchUrl(
                                      Uri.parse(
                                        "https://contracts.saudieng.sa/",
                                      ),
                                    );
                                  },
                                  child: Text("request_contract".tr()),
                                )
                              : const SizedBox.shrink(),
                        ],
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
