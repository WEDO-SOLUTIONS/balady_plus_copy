import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/features/classification_certificate/data/model/search_request/search_request_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../bloc/classification_certificate_list_cubit.dart';
import '../widgets/classification_certificate_list_widget.dart';

class ClassificationCertificateListScreen extends StatefulWidget {
  const ClassificationCertificateListScreen({super.key});

  @override
  State<ClassificationCertificateListScreen> createState() =>
      _ClassificationCertificateListScreenState();
}

class _ClassificationCertificateListScreenState
    extends State<ClassificationCertificateListScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SearchRequestModel searchRequestModel =
        ModalRoute.of(context)!.settings.arguments as SearchRequestModel;
    return BlocProvider(
      create: (context) => ClassificationCertificateListCubit(
        searchRequestModel: searchRequestModel,
      ),
      child: Scaffold(
        appBar: DefaultAppBarWidget(
            title: 'classification_certificate_verify'.tr()),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                "classification_certificate_verification_inquiry_result".tr(),
                style: Theme.of(context).textTheme.titleLarge!.copyWith(),
              ),
              const Expanded(child: ClassificationCertificateListWidget()),
            ],
          ),
        ),
      ),
    );
  }
}
