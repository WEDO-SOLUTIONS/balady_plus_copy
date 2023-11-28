import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/services/local/helpers.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_cupertino_drop_down_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/radio_buttons/custom_check_box_widget.dart';
import '../../../../new_appointment/presentation/core/models/lookup_list_model.dart';
import '../../../../vd/presentation/widgets/vd_header_desc_widget.dart';
import '../../blocs/ekram_book_cemetry/ekram_book_cemetry_bloc.dart';
import 'cemetry_previous_next_buttons.dart';

class AgreementSection extends StatelessWidget {
  const AgreementSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EkramBookCemetryBloc, EkramBookCemetryState>(
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
                        header: "cemetry_info".tr(),
                      ),
                      CustomLookUpLongDialog(
                        items: state.cemetryTypeItems ?? [],
                        value: state.selectedCemetryType,
                        onEmptyList: () async {
                          return context
                              .read<EkramBookCemetryBloc>()
                              .getCemetryTypeItemsHandler();
                        },
                        onChangeType: (LookUpItem? item) {
                          if (item != null) {
                            context
                                .read<EkramBookCemetryBloc>()
                                .add(ChangeCemetryTypeEvent(item: item));
                          }
                        },
                        label: ("cemetry_type").tr(),
                        hint: ("cemetry_type").tr(),
                      ),
                      CustomLookUpLongDialog(
                        items: state.cemetrySizeItems ?? [],
                        value: state.selectedCemetrySize,
                        onEmptyList: () async {
                          return context
                              .read<EkramBookCemetryBloc>()
                              .getCemetrySizeItemsHandler();
                        },
                        onChangeType: (LookUpItem? item) {
                          if (item != null) {
                            context
                                .read<EkramBookCemetryBloc>()
                                .add(ChangeCemetrySizeEvent(item: item));
                          }
                        },
                        label: ("cemetry_size").tr(),
                        hint: ("cemetry_size").tr(),
                      ),
                      CustomLookUpLongDialog(
                        items: state.cemetries ?? [],
                        value: state.selectedCemetry,
                        onEmptyList: () async {
                          return context
                              .read<EkramBookCemetryBloc>()
                              .add(GetCemetriesEvent());
                        },
                        onChangeType: (LookUpItem? item) {
                          if (item != null) {
                            context
                                .read<EkramBookCemetryBloc>()
                                .add(ChangeCemetryEvent(item: item));
                          }
                        },
                        label: Helpers.translatingWord("cemetry_name"),
                        hint: Helpers.translatingWord("cemetry_name"),
                      ),
                      CustomCheckBoxTopStartWidget(
                          onSelected: (value) {
                            context
                                .read<EkramBookCemetryBloc>()
                                .add(ChangeAgreementEvent(isagree: value));
                          },
                          backgroundColor: Colors.white,
                          checkboxValue: state.agreement ?? false,
                          containerBackgroundColor: Colors.transparent,
                          borderSelectedColor: Colors.transparent,
                          borderColor: Colors.transparent,
                          checkBoxAlignment: AlignmentDirectional.topStart,
                          titleSize: 14,
                          checkboxSize: 1,
                          verticalPadding: 5,
                          title: ("agreement_text").tr().replaceAll(
                              "{}", CommonProperties.userInfo?.arName ?? ""))
                    ],
                  ),
                ),
              ),
            ),
            CemetryreviousNextButtons()
          ],
        );
      },
    );
  }
}
