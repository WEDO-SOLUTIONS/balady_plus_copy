import 'package:balady_plus/app/features/classification_certificate/persentation/classification_certificate_details/bloc/classification_certificate_details_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:open_file_plus/open_file_plus.dart';

import '../bloc/classification_certificate_details_cubit.dart';

class AttachedButtonWidget extends StatelessWidget {
  final SuccessDetailsClassificationCertificateState state;

  const AttachedButtonWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    ClassificationCertificateDetailsCubit cubit =
        context.read<ClassificationCertificateDetailsCubit>();

    if (state.classificationCertificateDetails.attachLink.isNotEmpty) {
      if (state is LoadingAttachedCertificateState) {
        return const Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(child: CircularProgressIndicator()),
        );
      } else {
        return OutlinedButton(
          onPressed: () {
            if (state is SuccessAttachedCertificateState) {
              // Open File From file path
              OpenFile.open(
                (state as SuccessAttachedCertificateState).file.path,
              );
            } else {
              cubit.getAttachedFile(
                attachUrl: state.classificationCertificateDetails.attachLink,
                nameFile:
                    "${state.classificationCertificateDetails.serialNumber}${state.classificationCertificateDetails.classificationGrade}",
              );
            }
          },
          child: Text("download_certificate_classification".tr()),
        );
      }
    }
    return const SizedBox.shrink();
  }
}
