import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_cupertino_drop_down_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/radio_buttons/custom_radio_button_widget%20copy.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/ekram/data/model/cemetries_params.dart';
import 'package:balady_plus/app/features/ekram/data/model/mosque_ghusl_places_params.dart';
import 'package:balady_plus/app/features/ekram/data/model/transportation_companies_params.dart';
import 'package:balady_plus/app/features/ekram/domain/entities/get_cemetries_params.dart';
import 'package:balady_plus/app/features/ekram/ekram_exports.dart';
import 'package:balady_plus/app/features/ekram/presentation/widgets/ekram_book_cemetry/gorgian_date_widget.dart';
import 'package:balady_plus/app/features/ekram/presentation/widgets/ekram_book_cemetry/hijri_date_widget.dart';
import 'package:balady_plus/app/features/ekram/presentation/widgets/transportation_request_widgets/burial_date_gregorian.dart';
import 'package:balady_plus/app/features/ekram/presentation/widgets/transportation_request_widgets/burial_date_hijri.dart';
import 'package:balady_plus/app/features/ekram/presentation/widgets/transportation_request_widgets/death_date_gregorian.dart';
import 'package:balady_plus/app/features/ekram/presentation/widgets/transportation_request_widgets/death_date_hijri.dart';
import 'package:balady_plus/app/features/new_appointment/presentation/core/models/lookup_list_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../../core/services/local/helpers.dart';
import '../../../../vd/presentation/widgets/vd_header_desc_widget.dart';

class DeathAndBurialInfoSection extends StatelessWidget {
  const DeathAndBurialInfoSection({super.key});

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
                  margin: const EdgeInsets.only(top: 24, left: 16, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      VdHeaderDesc(
                        header: Helpers.translatingWord("deathInfo"),
                      ),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15.0)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(IconPath.editIcon),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'deathData'.tr(),
                                  style: const TextStyle(
                                    color: AppColor.black,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            ),
                            DeathDateHijri(),
                            DeathDateGregorian(),
                            CustomLookUpLongDialog(
                              items: state.countries ?? [],
                              value: state.selectedDeathCountry,
                              onEmptyList: () async {
                                return context
                                    .read<EkramRequestTransportationBloc>()
                                    .getCountries();
                              },
                              onChangeType: (LookUpItem? item) {
                                print(item?.name);
                                if (item != null) {
                                  context
                                      .read<EkramRequestTransportationBloc>()
                                      .add(ChangeDeathCountryEvent(item: item));
                                }
                              },
                              label:
                                  "${Helpers.translatingWord("ekram_death_country")} *",
                              hint: Helpers.translatingWord(
                                  "ekram_death_country"),
                            ),
                            state.selectedDeathCountry?.id == 1
                                ? CustomLookUpLongDialog(
                                    items: state.cities ?? [],
                                    value: state.selectedDeathCity,
                                    onEmptyList: () async {
                                      return context
                                          .read<
                                              EkramRequestTransportationBloc>()
                                          .getCitiesHandler();
                                    },
                                    onChangeType: (LookUpItem? item) {
                                      print(item?.name);
                                      if (item != null) {
                                        context
                                            .read<
                                                EkramRequestTransportationBloc>()
                                            .add(ChangeDeathCityEvent(
                                                item: item));
                                      }
                                    },
                                    label: ("ekram_death_city").tr(),
                                    hint: ("ekram_death_city").tr(),
                                  )
                                : CustomLookUpLongDialog(
                                    items: state.bodyArrivalCities ?? [],
                                    value: state.selectedBodyArrivalCity,
                                    onEmptyList: () async {
                                      return context
                                          .read<
                                              EkramRequestTransportationBloc>()
                                          .getCitiesHandler();
                                    },
                                    onChangeType: (LookUpItem? item) {
                                      print(item?.name);
                                      if (item != null) {
                                        context
                                            .read<
                                                EkramRequestTransportationBloc>()
                                            .add(ChangebodyArrivalCitiesEvent(
                                                item: item));
                                      }
                                    },
                                    label: ("arrivalCity").tr(),
                                    hint: ("arrivalCity").tr(),
                                  ),
                            CustomLookUpLongDialog(
                              items: state.hospitals ?? [],
                              value: state.selectedHospital,
                              onEmptyList: () async {
                                return context
                                    .read<EkramRequestTransportationBloc>()
                                    .add(GetHospitalsEvent(
                                        city: state.selectedDeathCity ??
                                            LookUpItem()));
                              },
                              onChangeType: (LookUpItem? item) {
                                print(item?.name);
                                if (item != null) {
                                  context
                                      .read<EkramRequestTransportationBloc>()
                                      .add(ChangeHospitalEvent(item: item));
                                }
                              },
                              label: ("ekramHospital").tr(),
                              hint: ("ekramHospital").tr(),
                            ),
                            CustomTextWidget(
                              ("burialDestination").tr(),
                              fontColor: AppColor.blackModern700Light,
                              fontSize: 17.0,
                              textAlign: TextAlign.start,
                              fontWeight: AppFontWeight.bold,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: CustomRadioButtonEnd<bool>(
                                    title: ("burial_in_death_city").tr(),
                                    value: true,
                                    currentSelected:
                                        state.isBurialInsideDeathCity == true,
                                    onChange: (bool item) {
                                      context
                                          .read<
                                              EkramRequestTransportationBloc>()
                                          .add(
                                              ChangeIsBurialInsideDeathCityEvent(
                                                  isBurialInsideDeathCity:
                                                      true));
                                    },
                                    endRadio: false,
                                    unSelectedBackgroundColor:
                                        Colors.transparent,
                                    textSize: 16,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: CustomRadioButtonEnd<bool>(
                                    title: ("burial_in_other_city").tr(),
                                    value: true,
                                    currentSelected:
                                        state.isBurialInsideDeathCity == false,
                                    onChange: (bool item) {
                                      context
                                          .read<
                                              EkramRequestTransportationBloc>()
                                          .add(
                                              ChangeIsBurialInsideDeathCityEvent(
                                                  isBurialInsideDeathCity:
                                                      false));
                                    },
                                    endRadio: false,
                                    unSelectedBackgroundColor:
                                        Colors.transparent,
                                    textSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            state.isBurialInsideDeathCity == false
                                ? CustomLookUpLongDialog(
                                    items: state.cities ?? [],
                                    value: state.selectedBurialCity,
                                    isDisbaled: false,
                                    onEmptyList: () async {
                                      return context
                                          .read<
                                              EkramRequestTransportationBloc>()
                                          .getCitiesHandler();
                                    },
                                    onChangeType: (LookUpItem? item) {
                                      print(item?.name);
                                      if (item != null) {
                                        context
                                            .read<
                                                EkramRequestTransportationBloc>()
                                            .add(ChangeBurialCityEvent(
                                                item: item));
                                      }
                                    },
                                    label: "burial_city".tr(),
                                    hint: "",
                                  )
                                : SizedBox.shrink(),
                            BurialDateHijri(),
                            BurialDateGorgian(),
                            CustomLookUpLongDialog(
                              items: state.prayers ?? [],
                              value: state.selectedPrayer,
                              onEmptyList: () async {
                                context
                                    .read<EkramRequestTransportationBloc>()
                                    .getPrayers();
                              },
                              onChangeType: (LookUpItem? item) {
                                if (item != null) {
                                  context
                                      .read<EkramRequestTransportationBloc>()
                                      .add(ChangePrayerEvent(item: item));
                                }
                              },
                              label: Helpers.translatingWord(
                                  "cemetry_deceassed_burial_time"),
                              hint: Helpers.translatingWord(
                                  "cemetry_deceassed_burial_time"),
                            ),
                            Row(
                              children: [
                                SvgPicture.asset(IconPath.editIcon),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'transferInfo'.tr(),
                                  style: const TextStyle(
                                    color: AppColor.black,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            ),
                            CustomVerticalSpace(height: 10),
                            CustomTextWidget(
                              "is_deaceased_requrie_special_transfer".tr(),
                              fontColor: AppColor.blackModern700Light,
                              fontSize: 16.0,
                              maxLines: 2,
                              textAlign: TextAlign.start,
                              fontWeight: AppFontWeight.bold,
                            ),
                            CustomVerticalSpace(height: 10),
                            CustomRadioButtonEnd<bool>(
                              title: "yes".tr(),
                              value: true,
                              currentSelected:
                                  state.isSpecialTransferNeeded == true,
                              onChange: (bool item) {
                                context
                                    .read<EkramRequestTransportationBloc>()
                                    .add(ChangeIsNeedSpecialTransferEvent(
                                        isNeeded: true));
                              },
                              endRadio: false,
                              unSelectedBackgroundColor: Colors.transparent,
                              textSize: 16,
                            ),
                            CustomVerticalSpace(height: 10),
                            CustomRadioButtonEnd<bool>(
                              title: "no".tr(),
                              value: true,
                              currentSelected:
                                  state.isSpecialTransferNeeded == false,
                              onChange: (bool item) {
                                context
                                    .read<EkramRequestTransportationBloc>()
                                    .add(ChangeIsNeedSpecialTransferEvent(
                                        isNeeded: false));
                              },
                              endRadio: false,
                              unSelectedBackgroundColor: Colors.transparent,
                              textSize: 16,
                            ),
                            state.isSpecialTransferNeeded ?? false
                                ? CustomLookUpLongDialog(
                                    items: state.specialTransportReasons ?? [],
                                    value: state.selectedSpecialTransportReason,
                                    onChangeType: (LookUpItem? item) {
                                      context
                                          .read<
                                              EkramRequestTransportationBloc>()
                                          .add(
                                              ChangeSpecialTransportReasonsEvent(
                                                  item: item));
                                    },
                                    onEmptyList: () async {
                                      context
                                          .read<
                                              EkramRequestTransportationBloc>()
                                          .getSpecialTransportReasons();
                                    },
                                    label: ("reasonForSpecialTransfer").tr(),
                                    hint: ("reasonForSpecialTransfer").tr(),
                                  )
                                : SizedBox.shrink(),
                            CustomLookUpLongDialog(
                              items: state.cemetryTypeItems ?? [],
                              value: state.selectedCemetryType,
                              onEmptyList: () async {
                                return context
                                    .read<EkramRequestTransportationBloc>()
                                    .getCemetryTypeItemsHandler();
                              },
                              onChangeType: (LookUpItem? item) {
                                if (item != null) {
                                  context
                                      .read<EkramRequestTransportationBloc>()
                                      .add(ChangeCemetryTypeItemsEvent(
                                          item: item));
                                }
                              },
                              label: ("cemetry_type").tr(),
                              hint: ("cemetry_type").tr(),
                            ),
                            CustomLookUpLongDialog(
                              items: state.cemetries ?? [],
                              value: state.selectedCemetry,
                              onEmptyList: () async {
                                context
                                    .read<EkramRequestTransportationBloc>()
                                    .add(GetCemetriesEvent(
                                        params: CemetriesParams(
                                            deathCountryId:
                                                state.selectedDeathCountry?.id,
                                            deathCityId:
                                                state.selectedDeathCity?.id,
                                            burialCityId:
                                                state.selectedBurialCity?.id ??
                                                    state.selectedDeathCity?.id,
                                            specialTransportReasonId: state
                                                .selectedSpecialTransportReason
                                                ?.id,
                                            prayId: state.selectedPrayer?.id,
                                            burialDate: state.burialDateHijri,
                                            deathDate: state.deathDateHijri,
                                            graveTypeId:
                                                state.selectedCemetryType?.id,
                                            age: state.requestDetailsModel
                                                ?.deathInfo?.age),
                                        requestId: state.requestId!));
                              },
                              onChangeType: (LookUpItem? item) {
                                if (item != null) {
                                  context
                                      .read<EkramRequestTransportationBloc>()
                                      .add(ChangeCemetryItemsEvent(item: item));
                                }
                              },
                              label: ("cemeteryName").tr(),
                              hint: ("cemeteryName").tr(),
                            ),
                            CustomLookUpLongDialog(
                              items: state.transportationNames ?? [],
                              value: state.selectedTransportationName,
                              onEmptyList: () async {
                                context
                                    .read<EkramRequestTransportationBloc>()
                                    .add(GetTransportationNamesEvent(
                                        params: TransportationCompaniesParams(
                                            cemeteryId:
                                                state.selectedCemetry?.id,
                                            deathCityId:
                                                state.selectedDeathCity?.id),
                                        requestId: state.requestId!));
                              },
                              onChangeType: (LookUpItem? item) {
                                if (item != null) {
                                  context
                                      .read<EkramRequestTransportationBloc>()
                                      .add(ChangeTransportationNameEvent(
                                          item: item));
                                }
                              },
                              label: ("ekram_orgnization_name").tr(),
                              hint: ("ekram_orgnization_name").tr(),
                            ),
                            CustomLookUpLongDialog(
                              items: state.laundries ?? [],
                              value: state.selectedlaundry,
                              onEmptyList: () async {
                                context
                                    .read<EkramRequestTransportationBloc>()
                                    .add(GetLandriesEvent(
                                        params: MosqueGhuslPlacesParams(
                                            burialDate: state.burialDateHijri,
                                            gender: state.requestDetailsModel
                                                ?.deceasedInfo?.gender),
                                        cityId: state.selectedBurialCity?.id));
                              },
                              onChangeType: (LookUpItem? item) {
                                if (item != null) {
                                  context
                                      .read<EkramRequestTransportationBloc>()
                                      .add(ChangeLandriesEvent(item: item));
                                }
                              },
                              label: ("ekram_laundry").tr(),
                              hint: ("ekram_laundry").tr(),
                            ),
                            CustomLookUpLongDialog(
                              items: state.mosques ?? [],
                              value: state.selectedMosque,
                              onEmptyList: () async {
                                context
                                    .read<EkramRequestTransportationBloc>()
                                    .add(GetMosquesEvent(
                                        params: MosqueGhuslPlacesParams(
                                            burialDate: state.burialDateHijri,
                                            gender: state.requestDetailsModel
                                                ?.deceasedInfo?.gender),
                                        cityId: state.selectedBurialCity?.id));
                              },
                              onChangeType: (LookUpItem? item) {
                                if (item != null) {
                                  context
                                      .read<EkramRequestTransportationBloc>()
                                      .add(ChangeMosqueEvent(item: item));
                                }
                              },
                              label: ("the_mosque").tr(),
                              hint: ("the_mosque").tr(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            EkramPreviousNextButtons(
              btnPressed: () {
                context
                    .read<EkramRequestTransportationBloc>()
                    .add(GoToNextPageEvent());
              },
            )
          ],
        );
      },
    );
  }
}
