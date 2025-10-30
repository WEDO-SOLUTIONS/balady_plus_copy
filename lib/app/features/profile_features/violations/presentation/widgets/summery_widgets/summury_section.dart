import 'package:balady_plus/app/features/profile_features/violations/presentation/widgets/summery_widgets/request_data_summury_widget.dart';
import 'package:balady_plus/app/features/profile_features/violations/presentation/widgets/summery_widgets/user_data_summury_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../_shared_feature_/shared_feature_exports.dart';
import '../../../../../vd/vd_exports.dart';
import '../../create_objection_bloc/create_objection_bloc.dart';
import '../create_objection_page/objection_previous_next_buttons.dart';
import 'description_summury_widget.dart';

class SummurySection extends StatelessWidget {
  const SummurySection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateObjectionBloc, CreateObjectionState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.only(top: 24, left: 16, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      VdHeaderDesc(
                        header: ("request_data").tr(),
                      ),
                      RequestDataSummuryWidget(),
                      CustomVerticalSpace(height: 16),
                      UserDataSummuryWidget(),
                      CustomVerticalSpace(height: 16),
                      DescriptionSummuryWidget(),
                      CustomVerticalSpace(height: 16),
                    ],
                  ),
                ),
              ),
            ),
            const ObjectionsNextButtons()
          ],
        );
      },
    );
  }
}
