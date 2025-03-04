import 'package:balady_plus/app/core/services/local/helpers.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/components/bottom_sheets/generic_bottom_sheet_list.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/dialogs/bottom_sheet_dialogs.dart';
import 'package:balady_plus/app/features/classification_certificate/persentation/classification_certificate_verify/bloc/classification_certificate_verify_bloc.dart';
import 'package:balady_plus/app/features/classification_certificate/persentation/classification_certificate_verify/widgets/title_with_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../core/classification_certificate_routes/classification_certificate_route_names.dart';
import '../../../data/model/lookups/activity_lookups_model.dart';
import '../../../data/model/lookups/city_lookups_model.dart';
import '../../../data/model/lookups/classification_certificate_lookup_model.dart';

class AdvancedSearchWidget extends StatelessWidget {
  final AdvancedSearchState state;

  const AdvancedSearchWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    ClassificationCertificateVerifyBloc bloc =
        context.read<ClassificationCertificateVerifyBloc>();

    return Column(
      children: [
        Row(
          children: [
            Flexible(
              fit: FlexFit.tight,
              child: Text(
                "please_enter_search_options".tr(),
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
              ),
            ),
            const SizedBox(width: 12),
            TextButton(
              onPressed: () {
                context.read<ClassificationCertificateVerifyBloc>().add(
                      SelectSearchMethodClassificationCertificateState(
                        typeMethod: state.typeMethod,
                      ),
                    );
              },
              child: Text("clear_all".tr()),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TitleWithWidget(
          title: 'type',
          isRequired: true,
          widget: DropdownButtonFormField<ClassificationCertificateLookupModel>(
            hint: Text("select".tr()),
            value: state.searchRequestModel.classificationType,
            icon: Image.asset(IconPath.arrowCircleDown, width: 24, height: 24),
            validator: (value) =>
                value == null ? 'most_selected_field'.tr() : null,
            onChanged: (ClassificationCertificateLookupModel? menu) {
              // Cull Action Update States
              if (menu != null &&
                  state.searchRequestModel.classificationType != menu) {
                bloc.add(
                  SelectClassificationTypeState(classificationType: menu),
                );
              }
            },
            items: state.classificationType
                .map<DropdownMenuItem<ClassificationCertificateLookupModel>>(
              (ClassificationCertificateLookupModel item) {
                return DropdownMenuItem<ClassificationCertificateLookupModel>(
                  value: item,
                  child: Text(
                    "locale".tr() == "ar" ? item.valueAr : item.valueEn,
                  ),
                );
              },
            ).toList(),
          ),
        ),
        const SizedBox(height: 12),
        if (state is AdvancedSearchByClassificationTypeState)
          TitleWithWidget(
            title: 'sector',
            isRequired: true,
            widget:
                DropdownButtonFormField<ClassificationCertificateLookupModel>(
              hint: Text("select_sector".tr()),
              value: state.searchRequestModel.sector,
              isExpanded: true,
              icon: Image.asset(
                IconPath.arrowCircleDown,
                width: 24,
                height: 24,
              ),
              validator: (value) =>
                  value == null ? 'most_selected_field'.tr().tr() : null,
              onChanged: (ClassificationCertificateLookupModel? menu) {
                // Cull Action Update States
                if (menu != null && state.searchRequestModel.sector != menu) {
                  bloc.add(
                    SelectSectorState(sector: menu),
                  );
                }
              },
              items: (state as AdvancedSearchByClassificationTypeState)
                  .sectors
                  .map<DropdownMenuItem<ClassificationCertificateLookupModel>>(
                (ClassificationCertificateLookupModel item) {
                  return DropdownMenuItem<ClassificationCertificateLookupModel>(
                    value: item,
                    child: Text(
                      "locale".tr() == "ar" ? item.valueAr : item.valueEn,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                },
              ).toList(),
            ),
          ),
        const SizedBox(height: 12),
        TitleWithWidget(
          title: 'city',
          isRequired: true,
          widget: TextFormField(
            keyboardType: TextInputType.text,
            readOnly: true,
            controller: TextEditingController(
              text: state.searchRequestModel.city?.text,
            ),
            onTap: () async {
              BottomSheetDialog.showDraggableSheet<CityLookupsModel>(
                context,
                currentRouteName: ClassificationCertificateRouteName.classificationCertificateVerifyScreen,
                child: GenericBottomSheetList<CityLookupsModel>(
                  title: "city_select".tr(),
                  items: state.cities,
                  selectedValue: null,
                  onTap: (item) {
                    // Cull Action Update States الريض
                    if (state.searchRequestModel.city != item) {
                      bloc.add(
                        //
                        UpdateRequestModelAdvancedSearchState(
                          searchRequestModel: state.searchRequestModel.copyWith(
                            city: item,
                          ),
                        ),
                      );
                    }
                    Navigator.of(context).pop();
                  },
                ),
              );
            },
            decoration: InputDecoration(
              hintText: "city_select".tr(),
              suffixIcon: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.asset(
                  IconPath.arrowCircleDown,
                  width: 24,
                  height: 24, // العقيق
                ),
              ),
            ),
            validator: (text) =>
                (text?.isEmpty ?? true) ? 'most_selected_field'.tr() : null,
          ),
        ),
        const SizedBox(height: 12),
        if (state is AdvancedMethodBySectorsState)
          TitleWithWidget(
            title: 'activity',
            widget: DropdownButtonFormField<ActivityLookupsModel>(
              hint: Text("select_activity".tr()),
              value: state.searchRequestModel.activity,
              isExpanded: true,
              icon: Image.asset(
                IconPath.arrowCircleDown,
                width: 24,
                height: 24,
              ),
              onChanged: (ActivityLookupsModel? activity) {
                // Cull Action Request model
                if (activity != null &&
                    state.searchRequestModel.activity != activity) {
                  bloc.add(
                    UpdateRequestModelAdvancedSearchState(
                      searchRequestModel: state.searchRequestModel.copyWith(
                        activity: activity,
                      ),
                    ),
                  );
                }
              },
              items: (state as AdvancedMethodBySectorsState)
                  .activity
                  .map<DropdownMenuItem<ActivityLookupsModel>>(
                (ActivityLookupsModel service) {
                  return DropdownMenuItem<ActivityLookupsModel>(
                    value: service,
                    child: Text(
                      service.activityValue,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                },
              ).toList(),
            ),
          ),
        const SizedBox(height: 12),
        TitleWithWidget(
          title: 'certificate_degree',
          widget: DropdownButtonFormField<ClassificationCertificateLookupModel>(
            hint: Text("select_degree".tr()),
            icon: Image.asset(
              IconPath.arrowCircleDown,
              width: 24,
              height: 24,
            ),
            value: state.searchRequestModel.classificationGrade,
            onChanged: (ClassificationCertificateLookupModel? grade) {
              // Cull Action Request model
              if (grade != null &&
                  state.searchRequestModel.classificationGrade != grade) {
                bloc.add(
                  UpdateRequestModelAdvancedSearchState(
                    searchRequestModel: state.searchRequestModel.copyWith(
                      classificationGrade: grade,
                    ),
                  ),
                );
              }
            },
            items: state.degrees
                .map<DropdownMenuItem<ClassificationCertificateLookupModel>>(
              (ClassificationCertificateLookupModel service) {
                return DropdownMenuItem<ClassificationCertificateLookupModel>(
                  value: service,
                  child: Text(
                    "locale".tr() == "ar" ? service.valueAr : service.valueEn,
                  ),
                );
              },
            ).toList(),
          ),
        ),
        const SizedBox(height: 12),
        ////////////////////////////
        TitleWithWidget(
          title: 'certificate_expiration_date_from',
          widget: TextFormField(
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            readOnly: true,
            controller: state.searchRequestModel.expiryDateFrom != null
                ? TextEditingController(
                    text: DateFormat(
                      "locale".tr() == "ar" ? 'yyyy/MM/dd' : 'dd/MM/yyyy',
                      "locale".tr(),
                    ).format(state.searchRequestModel.expiryDateFrom!),
                  )
                : null,
            onTap: () async {
              DateTime? date = await showDatePicker(
                context: context,
                firstDate: DateTime(1900), //
                lastDate: DateTime.now(), //
              );
              if (date != null) {
                bloc.add(
                  UpdateRequestModelAdvancedSearchState(
                    searchRequestModel: state.searchRequestModel.copyWith(
                      expiryDateFrom: date,
                    ),
                  ),
                );
              }
            },
            decoration: InputDecoration(
              hintText: "select_date".tr(),
              suffixIcon: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SvgPicture.asset(
                  IconPath.calendar,
                ),
              ),
            ),
            // validator: (text) => (text?.isNotEmpty ?? true) ? "" : null,
          ),
        ),
        const SizedBox(height: 12),
        TitleWithWidget(
          title: 'certificate_expiration_date_to',
          widget: TextFormField(
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            readOnly: true,
            controller: state.searchRequestModel.expiryDateTo != null
                ? TextEditingController(
                    text: DateFormat(
                      "locale".tr() == "ar" ? 'yyyy/MM/dd' : 'dd/MM/yyyy',
                      "locale".tr(),
                    ).format(state.searchRequestModel.expiryDateTo!),
                  )
                : null,
            onTap: () async {
              DateTime? date = await showDatePicker(
                context: context,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(
                  const Duration(days: 365 * 4),
                ),
              );
              if (date != null) {
                bloc.add(
                  UpdateRequestModelAdvancedSearchState(
                    searchRequestModel: state.searchRequestModel.copyWith(
                      expiryDateTo: date,
                    ),
                  ),
                );
              }
            },
            decoration: InputDecoration(
              hintText: "select_date".tr(),
              suffixIcon: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SvgPicture.asset(
                  IconPath.calendar,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        TitleWithWidget(
          title: 'phoneNumber',
          widget: TextFormField(
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            controller: state.phoneNumberTextEditingController ,
            decoration: InputDecoration(
              hintText: "phoneNumberFieldHint".tr(),
            ),
            validator: (phoneNumber) {
              if (phoneNumber == null || phoneNumber.isEmpty) {
                return null;
              }
              String? error = Helpers.validateMobile(phoneNumber);
              if (error != null) {
                bloc.add(
                  UpdateRequestModelAdvancedSearchState(
                    searchRequestModel: state.searchRequestModel.copyWith(
                      phoneNumber: phoneNumber,
                    ),
                  ),
                );
              }
              return error;
            },
          ),
        ),
        ////////////////////////////
        const SizedBox(height: 12),
        if (state is AdvancedSearchByClassificationTypeState)
          TitleWithWidget(
            title: 'service',
            widget:
                DropdownButtonFormField<ClassificationCertificateLookupModel>(
              hint: Text("select_service".tr()),
              icon: Image.asset(
                IconPath.arrowCircleDown,
                width: 24,
                height: 24,
              ),
              value: state.searchRequestModel.service,
              onChanged: (ClassificationCertificateLookupModel? service) {
                // Cull Action Request model
                if (service != null &&
                    state.searchRequestModel.service != service) {
                  bloc.add(
                    UpdateRequestModelAdvancedSearchState(
                      searchRequestModel: state.searchRequestModel.copyWith(
                        service: service,
                      ),
                    ),
                  );
                }
              },
              items: (state as AdvancedSearchByClassificationTypeState)
                  .services
                  .map<DropdownMenuItem<ClassificationCertificateLookupModel>>(
                (ClassificationCertificateLookupModel service) {
                  return DropdownMenuItem<ClassificationCertificateLookupModel>(
                    value: service,
                    child: Text(
                      "locale".tr() == "ar" ? service.valueAr : service.valueEn,
                    ),
                  );
                },
              ).toList(),
            ),
          ),
        const SizedBox(height: 12),
      ],
    );
  }
}
