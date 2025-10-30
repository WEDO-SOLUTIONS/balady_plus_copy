import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/enums/bloc_status.dart';
import '../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../vd/presentation/widgets/summery_widgets/field_data.dart';
import '../../../vd/presentation/widgets/vd_header_desc_widget.dart';
import '../create_objection_bloc/create_objection_bloc.dart';
import '../widgets/create_objection_page/objection_previous_next_buttons.dart';

class CreateObjectionRequestInfoPage extends StatefulWidget {
  const CreateObjectionRequestInfoPage({super.key});

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
                              subTitle: state.getObjectionTypeName),
                          const CustomVerticalSpace(height: 8),
                          FieldData(
                            title: ("objection_service_group").tr(),
                            subTitle: state.getServiceGroupName,
                          ),
                          const CustomVerticalSpace(height: 8),
                          FieldData(
                            title: ("objection_service").tr(),
                            subTitle: state.getServiceName,
                          ),
                          const CustomVerticalSpace(height: 8),
                          FieldData(
                            title: ("objection_municipality").tr(),
                            subTitle: state.getMunicipalityName,
                          ),
                          const CustomVerticalSpace(height: 8),
                          FieldData(
                            title: ("objection_sub_municipality").tr(),
                            subTitle: state.getSubMunicipalityName,
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
