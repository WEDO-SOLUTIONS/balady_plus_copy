import 'package:balady_plus/app/features/_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import 'package:balady_plus/app/features/ekram/ekram_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/services/local/helpers.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/constants.dart';
import '../../../../../core/utils/enums/app_font_weights.dart';
import '../../../../../core/utils/enums/enums.dart';
import '../../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_popups_widgets.dart';
import '../../../../vd/presentation/widgets/vd_header_desc_widget.dart';

class DeceasedInfoSection extends StatelessWidget {
  const DeceasedInfoSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EkramRequestTransportationBloc,
        EkramRequestTransportationState>(
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      VdHeaderDesc(
                        header:
                            Helpers.translatingWord("ekram_dead_deads_info"),
                      ),
                      ElevatedButtonWidget.primaryCustomBorder(
                        onPressed: () async {
                          final result =
                              await CustomPopUpsWidgets.showBottomSheet(context,
                                  child: AddDeceasedDialog(
                                    params: AddDeceasedDialogParams(
                                        deathCity: state.selectedCity,
                                        cities: state.cities,
                                        nationalities: state.nationalities,
                                        data: DeceasedInfoDto()),
                                  ),
                                  height: MediaQuery.of(context).size.height *
                                      0.95);
                          print(result);
                          context
                              .read<EkramRequestTransportationBloc>()
                              .add(AddDeceasedEvent(result));
                        },
                        text: "addDeceased".tr(),
                      ),
                      SizedBox(
                          child: ListView.builder(
                        itemCount: state.deceasedInfoDto?.length ?? 0,
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemBuilder: (ctx, index) {
                          return DeceasedCardWidget(
                            deceasedItem: state.deceasedInfoDto![index],
                            onDelete: () async {
                              bool r = await CustomPopUpsWidgets
                                  .showConfirmAppMessageDialog(
                                      context, ("delete_confirm").tr(),
                                      primaryBtn: () {
                                Navigator.of(context).pop(true);
                                context
                                    .read<EkramRequestTransportationBloc>()
                                    .add(DeleteDeceasedEvent(index: index));
                              });
                            },
                            onEdit: () async {
                              final result =
                                  await CustomPopUpsWidgets.showBottomSheet(
                                      context,
                                      child: AddDeceasedDialog(
                                        params: AddDeceasedDialogParams(
                                            deathCity: state.selectedCity,
                                            cities: state.cities,
                                            nationalities: state.nationalities,
                                            data:
                                                state.deceasedInfoDto![index]),
                                      ),
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.95);
                              print(result);
                              context
                                  .read<EkramRequestTransportationBloc>()
                                  .add(EditDeceasedEvent(
                                      index: index, data: result));
                            },
                          );
                        },
                      )),
                    ],
                  ),
                ),
              ),
            ),
            EkramPreviousNextButtons()
          ],
        );
      },
    );
  }
}
