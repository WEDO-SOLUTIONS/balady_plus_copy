import 'package:balady_plus/app/features/classification_certificate/persentation/classification_certificate_verify/utility/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../bloc/classification_certificate_verify_bloc.dart';
import '../title_with_widget.dart';
import 'search_normal_options_widget.dart';

class NormalSearchVerifiedByWidget extends StatelessWidget {
  final NormalSearchVerifiedByClassificationCertificateState state;

  const NormalSearchVerifiedByWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                "verified_by".tr(),
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
            TextButton(
              onPressed: () {
                context.read<ClassificationCertificateVerifyBloc>().add(
                      SelectSearchMethodClassificationCertificateState(
                        typeMethod: state.typeMethod,
                      ),
                    );
              },
              child: Text("edit".tr()),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SearchNormalOptionsWidget(
          type: state.normalSearchType,
          groupValue: state.normalSearchType,
        ),
        const SizedBox(height: 12),
        TitleWithWidget(
          title: state.normalSearchType.verifiedBy.title,
          widget: TextFormField(
            keyboardType: state.normalSearchType.verifiedBy.keyboardType,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              hintText: state.normalSearchType.verifiedBy.hintText.tr(),
            ),
            onChanged: (text) {
              state.searchRequestModel.searchQuery = text;
            },
            onSaved: (text) {
              state.searchRequestModel.searchQuery = text ?? "";
            },
            onFieldSubmitted: (text) {
              state.searchRequestModel.searchQuery = text;
            },
            validator: (text) {
              if (RegExp(state.normalSearchType.verifiedBy.regex)
                  .hasMatch(text ?? "")) {
                return null;
              }
              return state.normalSearchType.verifiedBy.validatorMessage.tr();
            },
          ),
        ),
      ],
    );
  }
}
