import 'package:balady_plus/app/features/classification_certificate/persentation/classification_certificate_verify/utility/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../core/classification_certificate_routes/classification_certificate_route_names.dart';
import '../bloc/classification_certificate_verify_bloc.dart';
import 'normal_search/search_normal_options_widget.dart';

class ActionButtonWidget extends StatelessWidget {
  const ActionButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ClassificationCertificateVerifyBloc bloc =
        context.read<ClassificationCertificateVerifyBloc>();
    return ElevatedButton(
      onPressed: () {
        if (bloc.formKey.currentState!.validate()) {
         var state = bloc.state;
          if(state is NormalSearchVerifiedByClassificationCertificateState) {
            Navigator.of(context).pushNamed(
                ClassificationCertificateRouteName.classificationCertificateListScreen,
                arguments: state.searchRequestModel,
            );
          } else if(state is AdvancedSearchState) {
    if(state is AdvancedMethodBySectorsState){
      state = state as AdvancedMethodBySectorsState;      
    } else if (state is AdvancedSearchByClassificationTypeState){
      state = state as AdvancedSearchByClassificationTypeState;
    }
    Navigator.of(context).pushNamed(
      ClassificationCertificateRouteName.classificationCertificateListScreen,
      arguments: state.searchRequestModel.copyWith(
        phoneNumber: state.phoneNumberTextEditingController.text
      )
    );
          }
        }
      },
      child: Text("search".tr()),
    );
  }
}
