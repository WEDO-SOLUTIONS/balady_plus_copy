import 'package:balady_plus/app/core/services/local/helpers.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/features/classification_certificate/persentation/classification_certificate_verify/bloc/classification_certificate_verify_bloc.dart';
import 'package:balady_plus/app/features/classification_certificate/persentation/classification_certificate_verify/widgets/title_with_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

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
            const Spacer(),
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
        TitleWithWidget(
          title: 'type',
          isRequired: true,
          widget: DropdownButtonFormField<ClassificationCertificateLookupModel>(
            hint: Text("select".tr()),
            value: state.searchRequestModel.classificationType,
            icon: Image.asset(IconPath.arrowCircleDown, width: 24, height: 24),
            validator: (value) => value == null ? 'field required'.tr() : null,
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
                  value == null ? 'field required'.tr() : null,
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
          widget: DropdownButtonFormField<CityLookupsModel>(
            hint: Text("city_select".tr()),
            value: state.searchRequestModel.city,
            icon: Image.asset(IconPath.arrowCircleDown, width: 24, height: 24),
            validator: (value) => value == null ? 'field required'.tr() : null,
            onChanged: (CityLookupsModel? menu) {
              // Cull Action Update States
              if (state.searchRequestModel.city != menu) {
                bloc.add(
                  UpdateRequestModelAdvancedSearchState(
                    searchRequestModel: state.searchRequestModel.copyWith(
                      city: menu,
                    ),
                  ),
                );
              }
            },
            items: state.cities.map<DropdownMenuItem<CityLookupsModel>>(
              (CityLookupsModel item) {
                return DropdownMenuItem<CityLookupsModel>(
                  value: item,
                  child: Text(item.city),
                );
              },
            ).toList(),
          ),
        ),
        const SizedBox(height: 12),
        if (state is AdvancedMethodBySectorsState)
          TitleWithWidget(
            title: 'activity',
            widget: DropdownMenu<ActivityLookupsModel>(
              width: double.maxFinite,
              expandedInsets: EdgeInsets.zero,
              hintText: "select_activity".tr(),
              requestFocusOnTap: true,
              enableFilter: true,
              trailingIcon: Image.asset(
                IconPath.arrowCircleDown,
                width: 24,
                height: 24,
              ),
              onSelected: (ActivityLookupsModel? activity) {
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
              dropdownMenuEntries: (state as AdvancedMethodBySectorsState)
                  .activity
                  .map<DropdownMenuEntry<ActivityLookupsModel>>(
                (ActivityLookupsModel service) {
                  return DropdownMenuEntry<ActivityLookupsModel>(
                    value: service,
                    label: service.activityValue,
                  );
                },
              ).toList(),
            ),
          ),
        const SizedBox(height: 12),
        TitleWithWidget(
          title: 'certificate_degree',
          widget: DropdownMenu<ClassificationCertificateLookupModel>(
            width: double.maxFinite,
            expandedInsets: EdgeInsets.zero,
            hintText: "select_degree".tr(),
            requestFocusOnTap: true,
            enableFilter: true,
            trailingIcon: Image.asset(
              IconPath.arrowCircleDown,
              width: 24,
              height: 24,
            ),
            onSelected: (ClassificationCertificateLookupModel? grade) {
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
            dropdownMenuEntries: state.degrees
                .map<DropdownMenuEntry<ClassificationCertificateLookupModel>>(
              (ClassificationCertificateLookupModel service) {
                return DropdownMenuEntry<ClassificationCertificateLookupModel>(
                  value: service,
                  label:
                      "locale".tr() == "ar" ? service.valueAr : service.valueEn,
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
            onTap: () {},
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
            onTap: () {},
            decoration: InputDecoration(
              hintText: "select_date".tr(),
              suffixIcon: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SvgPicture.asset(
                  IconPath.calendar,
                ),
              ),
            ),
            validator: (text) => (text?.isNotEmpty ?? true) ? "" : null,
          ),
        ),
        const SizedBox(height: 12),
        TitleWithWidget(
          title: 'phoneNumber',
          widget: TextFormField(
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              hintText: "phoneNumberFieldHint".tr(),
            ),
            validator: (text) {
              if (text == null || text.isEmpty) {
                return null;
              }
              return Helpers.validateMobile(text);
            },
          ),
        ),
        ////////////////////////////
        const SizedBox(height: 12),
        if (state is AdvancedSearchByClassificationTypeState)
          TitleWithWidget(
            title: 'service',
            widget: DropdownMenu<ClassificationCertificateLookupModel>(
              //initialSelection: menuItems.first,
              // controller: menuController,
              width: double.maxFinite,
              expandedInsets: EdgeInsets.zero,
              hintText: "select_service".tr(),
              requestFocusOnTap: true,
              enableFilter: true,
              trailingIcon: Image.asset(
                IconPath.arrowCircleDown,
                width: 24,
                height: 24,
              ),
              onSelected: (ClassificationCertificateLookupModel? service) {
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
              dropdownMenuEntries: (state
                      as AdvancedSearchByClassificationTypeState)
                  .services
                  .map<DropdownMenuEntry<ClassificationCertificateLookupModel>>(
                (ClassificationCertificateLookupModel service) {
                  return DropdownMenuEntry<
                      ClassificationCertificateLookupModel>(
                    value: service,
                    label: "locale".tr() == "ar"
                        ? service.valueAr
                        : service.valueEn,
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
