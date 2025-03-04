import 'package:balady_plus/app/commercial_model/features/posters/presentation/widgets/license_widgets/bottom_sheet_list.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/dialogs/bottom_sheet_dialogs.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/widgets/summery_widgets/field_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../../../features/_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';

import '../../blocs/posters_license_bloc.dart';

class CommercialPermitsScreen extends StatefulWidget {

  const CommercialPermitsScreen({super.key});

  @override
  State<CommercialPermitsScreen> createState() =>
      _CommercialPermitsScreenState();
}

class _CommercialPermitsScreenState extends State<CommercialPermitsScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostersLicenseBloc()
        ..add(
          const GetPostersGroupsEvent(),
        ),
      child: Scaffold(
        appBar: AppBar(
          title: Text("permits_for_licenes".tr()),
        ),
        body: BlocConsumer<PostersLicenseBloc, PostersLicenseState>(
          listener: (context, state) {},
          builder: (context, state) {
            return Container(
              color: AppColor.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ListView.builder(
                    itemCount: state.permitGroups?.length ?? 0,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        child: FieldData(
                            title: state.permitGroups?[index].name ?? ""),
                        onTap: () {
                          // widget.onSelect(state.permitGroups![index].id!);
                          if (state.permitGroups![index].id == 1042) {
                            BottomSheetDialog.showDraggableSheet(
                              context,
                              isFullHeight: true,
                              child: PermitsLicenseBottomSheetList(
                                groupId: state.permitGroups![index].id!,
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
                  if (state.status == BlocStatus.loading)
                    const CustomCircularLoadingWidget(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
