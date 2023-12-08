import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../_shared_feature_/shared_feature_exports.dart';
import '../../../../vd/presentation/widgets/summery_widgets/field_data.dart';
import '../../../../vd/vd_exports.dart';
import '../../violations_exports.dart';
import '../create_objection_bloc/create_objection_bloc.dart';
import '../widgets/create_objection_page/objection_previous_next_buttons.dart';

class CreateObjectionRequestInfoPage extends StatefulWidget {
  final ViolationsEntity? violationsEntity;
  const CreateObjectionRequestInfoPage({super.key, this.violationsEntity});

  @override
  State<CreateObjectionRequestInfoPage> createState() =>
      _CreateObjectionRequestInfoPageState();
}

class _CreateObjectionRequestInfoPageState
    extends State<CreateObjectionRequestInfoPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateObjectionBloc, CreateObjectionState>(
        listener: (context, state) {
      if (state.status == BlocStatus.failure) {
        CommonFunctions.showError(state.errorMessage ?? "");
      }
    }, builder: (context, state) {
      return Scaffold(
        backgroundColor: AppColor.scaffoldBackground,
        body: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      color: AppColor.scaffoldBackground,
                      margin: EdgeInsets.only(top: 24, left: 16, right: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          VdHeaderDesc(
                            header: ("objection_main_request_data").tr(),
                          ),
                          FieldData(
                            title: ("objection_complain").tr(),
                            subTitle: state.details?.objectionTypeName,
                          ),
                          const CustomVerticalSpace(height: 8),
                          FieldData(
                            title: ("objection_service_group").tr(),
                            subTitle: widget.violationsEntity?.applicationName,
                          ),
                          const CustomVerticalSpace(height: 8),
                          FieldData(
                            title: ("objection_service").tr(),
                            subTitle: widget.violationsEntity?.serviceName,
                          ),
                          const CustomVerticalSpace(height: 8),
                          FieldData(
                            title: ("objection_municipality").tr(),
                            subTitle: state.details?.municipalityName,
                          ),
                          const CustomVerticalSpace(height: 8),
                          FieldData(
                            title: ("objection_sub_municipality").tr(),
                            subTitle: state.details?.subMunicipalityName,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const ObjectionsNextButtons()
              ],
            ),
          ],
        ),
      );
    });
  }
}
