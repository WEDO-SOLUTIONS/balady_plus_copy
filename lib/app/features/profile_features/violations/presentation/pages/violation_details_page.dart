import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../_shared_feature_/shared_feature_exports.dart';
import '../../violations_exports.dart';

class ViolationsDetailsPage extends StatelessWidget {
  final ViolationsEntity violationsEntity;

  const ViolationsDetailsPage({
    super.key,
    required this.violationsEntity,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ViolationDetailsBloc()
        ..add(GetViolationDetailsEvent(
            params: violationsEntity.hashingViolationNumber ?? '')),
      child: Scaffold(
        appBar: DefaultAppBarWidget(
          title: "transaction_details_data".tr(),
        ),
        body: ViolationDetailBody(
          violationsEntity: violationsEntity,
        ),
      ),
    );
  }
}
