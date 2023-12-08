import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../core/utils/constants/dialog_names.dart';
import '../../../../../../core/utils/utils_exports.dart';
import '../../../../../_shared_feature_/shared_feature_exports.dart';
import '../../../municipal_advisor_exports.dart'
    show
        AccommodationTypeEntity,
        MunicipalAdvisorBloc,
        MunicipalAdvisorSelectAccommodationTypeEvent,
        MunicipalAdvisorState;

class AccommodationTypeSelector extends StatefulWidget {
  const AccommodationTypeSelector({super.key});

  @override
  State<AccommodationTypeSelector> createState() =>
      _AccommodationTypeSelectorState();
}

class _AccommodationTypeSelectorState extends State<AccommodationTypeSelector> {
  AccommodationTypeEntity? accommodationType;

  @override
  void initState() {
    super.initState();
    accommodationType =
        context.read<MunicipalAdvisorBloc>().state.selectedAccommodationType;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MunicipalAdvisorBloc, MunicipalAdvisorState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            CustomTextWidget(
              'municipalAdvisorChooseHint'.tr(),
              textStyle: AppStyle.subMessageTextStle,
            ),
            DropDownWithTitle(
              title: '',
              selectedValue: accommodationType?.name,
              onTap: () {
                final List<String> items =
                    state.accommodationTypes.map((e) => e.name).toList();
                BottomSheetDialog.showDraggableSheet(
                  context,
                  dialogKeyName: DialogName.municipalAdvisorAccomodation,
                  currentRouteName: RouteName.municipalAdvisor,
                  child: BottomSheetList(
                    title: "municipalAdvisorHotelTypeHint".tr(),
                    items: items,
                    selectedValue: accommodationType?.name,
                    onTap: (item) {
                      setState(() {
                        accommodationType = state.accommodationTypes
                            .where((e) => e.name == item)
                            .first;
                      });

                      Navigator.pop(context);
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            ElevatedButtonWidget.choose(
              onPressed: accommodationType == null
                  ? null
                  : () => context.read<MunicipalAdvisorBloc>().add(
                        MunicipalAdvisorSelectAccommodationTypeEvent(
                          accommodationType: accommodationType!,
                        ),
                      ),
            ),
          ],
        );
      },
    );
  }
}
