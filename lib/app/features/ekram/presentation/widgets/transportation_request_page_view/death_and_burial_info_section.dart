import 'package:balady_plus/app/commercial_model/features/commercial_license/commercial_license_exports.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_cupertino_drop_down_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/notes_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/radio_buttons/custom_radio_button_widget%20copy.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/ekram/data/model/cemetries_params.dart';
import 'package:balady_plus/app/features/ekram/data/model/mosque_ghusl_places_params.dart';
import 'package:balady_plus/app/features/ekram/data/model/transportation_companies_params.dart';
import 'package:balady_plus/app/features/ekram/ekram_exports.dart';
import 'package:balady_plus/app/features/ekram/presentation/widgets/transportation_request_widgets/burial_date_gregorian.dart';
import 'package:balady_plus/app/features/ekram/presentation/widgets/transportation_request_widgets/burial_date_hijri.dart';
import 'package:balady_plus/app/features/ekram/presentation/widgets/transportation_request_widgets/death_date_gregorian.dart';
import 'package:balady_plus/app/features/ekram/presentation/widgets/transportation_request_widgets/death_date_hijri.dart';
import 'package:balady_plus/app/features/new_appointment/presentation/core/models/lookup_list_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../../core/services/local/helpers.dart';
import '../../../../_shared_feature_/presentation/widgets/texts/custom_text_field_widget.dart';
import '../../../../vd/presentation/widgets/vd_header_desc_widget.dart';
import '../../../data/model/request_details_response_model/burial_info.dart';
import '../../../data/model/request_details_response_model/cemetery_data.dart';
import '../../../data/model/request_details_response_model/death_info.dart';
import '../../../data/model/request_details_response_model/transport_info.dart';
import '../../../data/model/reset_action_enum.dart';
import '../driver/trip_datetime_widget.dart';

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
                            DeathDateHijri(
                              currentDate: state
                                  .requestDetailsModel?.deathInfo?.deathDate,
                             // isDeathDatesDisabled: state.requestDetailsModel?.deceasedInfo?.deceasedDataSource == "SEHA",

                              isDeathDatesDisabled:state.isFieldDisabled(state.requestDetailsModel?.deceasedInfo?.deceasedDataSource , EditFiledActionEnum.DeathDate, null),
                              onChanged: (String? date) {
                                context
                                    .read<EkramRequestTransportationBloc>()
                                    .add(ChangeDeathInfoEvent(
                                        deathInfo: DeathInfo(
                                            deathDate:
                                                CommonFunctions.padHijriDate(
                                                    date!),
                                            gregorianDeathDate: CommonFunctions
                                                .hijriToGregorian(date))));
                              },
                            ),
                            DeathDateGregorian(
                              currentDate: state.requestDetailsModel?.deathInfo
                                  ?.gregorianDeathDate,
                             // isDeathDatesDisabled: state.requestDetailsModel?.deceasedInfo?.deceasedDataSource == "SEHA",
                              isDeathDatesDisabled:state.isFieldDisabled(state.requestDetailsModel?.deceasedInfo?.deceasedDataSource , EditFiledActionEnum.DeathDate, null),

                              onChanged: (String? date) {
                                context
                                    .read<EkramRequestTransportationBloc>()
                                    .add(ChangeDeathInfoEvent(
                                        deathInfo: DeathInfo(
                                            gregorianDeathDate:
                                                CommonFunctions.padHijriDate(
                                                    date!),
                                            deathDate: CommonFunctions
                                                .gregorianToHijri(date))));
                              },
                            ),
                            CustomLookUpLongDialog(
                              items: state.countries ?? [],
                              // isDisbaled:(state.editInfoSection==false&&( state.requestDetailsModel?.deceasedInfo?.deceasedDataSource=="SEHA"||state.requestDetailsModel?.deceasedInfo?.deceasedDataSource=="BALADY")),
                              isDisbaled:state.isFieldDisabled(state.requestDetailsModel?.deceasedInfo?.deceasedDataSource , EditFiledActionEnum.Country, null),

                              value: state.getCountryById(state
                                  .requestDetailsModel?.deathInfo?.countryId),
                              onEmptyList: () async {
                                return context
                                    .read<EkramRequestTransportationBloc>()
                                    .getCountries();
                              },
                              onChangeType: (LookUpItem? item) {
                                if (item != null) {
                                  if (item.id != null &&
                                      state.requestDetailsModel?.deathInfo
                                              ?.isCountryChanged(item.id!) ==
                                          true) {
                                    context
                                        .read<EkramRequestTransportationBloc>()
                                        .add(const ResetActionEvent(
                                            action: ResetActionEnum.Country));
                                  }

                                  context
                                      .read<EkramRequestTransportationBloc>()
                                      .add(ChangeDeathInfoEvent(
                                          deathInfo:
                                              DeathInfo(countryId: item.id!)));
                                }
                              },
                              label: Helpers.translatingWord(
                                  "ekram_death_country"),
                              hint: Helpers.translatingWord(
                                  "ekram_death_country"),
                            ),
                            CustomLookUpLongDialog(
                              showOptional: false,
                             // isDisbaled:(state.editInfoSection==false&&( state.requestDetailsModel?.deceasedInfo?.deceasedDataSource=="SEHA"||state.requestDetailsModel?.deceasedInfo?.deceasedDataSource=="BALADY")),
                              isDisbaled:state.isFieldDisabled(state.requestDetailsModel?.deceasedInfo?.deceasedDataSource , EditFiledActionEnum.DeathCity, null),


                              items: state.deathCities ?? [],
                              value: state.requestDetailsModel?.deathInfo
                                          ?.countryId ==
                                      1
                                  ? state.getDeathCityById(state
                                      .requestDetailsModel?.deathInfo?.cityId)
                                  : state.getDeathCityById(state
                                      .requestDetailsModel
                                      ?.deathInfo
                                      ?.corpseArrivalCityId),
                              onEmptyList: () async {
                                return context
                                    .read<EkramRequestTransportationBloc>()
                                    .getDeathCitiesHandler();
                              },
                              onChangeType: (LookUpItem? item) {
                                if (item != null) {
                                  if (item.id != null &&
                                      state.requestDetailsModel?.deathInfo
                                              ?.isCityChanged(item.id!) ==
                                          true) {
                                    context
                                        .read<EkramRequestTransportationBloc>()
                                        .add(const ResetActionEvent(
                                            action: ResetActionEnum.DeathCity));
                                  }

                                  if (state.requestDetailsModel?.deathInfo
                                          ?.countryId ==
                                      1) {
                                    context
                                        .read<EkramRequestTransportationBloc>()
                                        .add(ChangeDeathInfoEvent(
                                            deathInfo:
                                                DeathInfo(cityId: item.id)));
                                  } else {
                                    context
                                        .read<EkramRequestTransportationBloc>()
                                        .add(ChangeDeathInfoEvent(
                                            deathInfo: DeathInfo(
                                                corpseArrivalCityId: item.id)));
                                  }
                                  context
                                      .read<EkramRequestTransportationBloc>()
                                      .add(
                                        setBurialInfoEvent(
                                          burialInfo: BurialInfo(
                                            isBurialInsideDeathCity: state
                                                    .requestDetailsModel
                                                    ?.burialInfo
                                                    ?.isBurialInsideDeathCity ??
                                                true,
                                          ),
                                        ),
                                      );
                                }
                              },
                              label: state.requestDetailsModel?.deathInfo
                                          ?.countryId ==
                                      1
                                  ? ("ekram_death_city").tr()
                                  : ("arrivalCity").tr(),
                              hint: state.requestDetailsModel?.deathInfo
                                          ?.countryId ==
                                      1
                                  ? ("ekram_death_city").tr()

                                  : ("arrivalCity").tr(),
                            ),
                            state.requestDetailsModel?.deathInfo?.countryId == 1
                                ? Container()
                                : CustomTextFieldWidget(
                                    isRequired: true,
                                    label: "ekram_death_city".tr(),
                                    initialValue: state.requestDetailsModel
                                        ?.deathInfo?.cityOther,
                                    hintText: "ekram_death_city".tr(),
                                    keyboardType: TextInputType.name,
                                    onChanged: (String? text) {
                                      if (text != null) {
                                        context
                                            .read<
                                                EkramRequestTransportationBloc>()
                                            .add(ChangeDeathInfoEvent(
                                                deathInfo: DeathInfo(
                                                    cityOther: text)));
                                      }
                                    },
                                    onValidate: (String? value) {
                                      return null;
                                    }),
                            CustomLookUpLongDialog(
                              //isDisbaled: state.isHosptialDisabled(state.requestDetailsModel?.deathInfo?.hospitalId),

                              isDisbaled:state.isFieldDisabled(state.requestDetailsModel?.deceasedInfo?.deceasedDataSource , EditFiledActionEnum.Hospital, state.requestDetailsModel?.deathInfo?.hospitalId != null?"${state.requestDetailsModel?.deathInfo?.hospitalId}":null),

                              items: state.hospitals ?? [],
                              value: state.getHosptialById(
                                  state.requestDetailsModel?.deathInfo
                                      ?.hospitalId,
                                  state.requestDetailsModel?.deathInfo
                                      ?.hospitalName),
                              onEmptyList: () async {
                                return context
                                    .read<EkramRequestTransportationBloc>()
                                    .add(GetHospitalsEvent(
                                        cityId: state.requestDetailsModel
                                                    ?.deathInfo?.countryId ==
                                                1
                                            ? state.requestDetailsModel
                                                ?.deathInfo?.cityId
                                            : state
                                                .requestDetailsModel
                                                ?.deathInfo
                                                ?.corpseArrivalCityId));
                              },
                              onChangeType: (LookUpItem? item) {
                                if (item != null) {
                                  // if(item.id != null&& state.requestDetailsModel?.deathInfo?.isHostpitalChanged(item.id!)==true)
                                  // {
                                  //   context
                                  //       .read<EkramRequestTransportationBloc>().add(const ResetActionEvent(action:  ResetActionEnum.Hospital));
                                  // }

                                  context
                                      .read<EkramRequestTransportationBloc>()
                                      .add(ChangeDeathInfoEvent(
                                          deathInfo: DeathInfo(
                                              hospitalId: item.id,
                                              showHospitalOther:
                                                  item.isOther)));
                                }
                              },
                              label: ("ekramHospital").tr(),
                              hint: ("ekramHospital").tr(),
                            ),
                            state.requestDetailsModel?.deathInfo
                                        ?.showHospitalOther ==
                                    true
                                ? Column(
                                    children: [
                                      CustomTextFieldWidget(
                                          label: "hospital_name".tr(),
                                          initialValue: state
                                              .requestDetailsModel
                                              ?.deathInfo
                                              ?.hospitalOther,
                                          hintText: "hospital_name".tr(),
                                          onChanged: (String? text) {
                                            if (text != null) {
                                              context
                                                  .read<
                                                      EkramRequestTransportationBloc>()
                                                  .add(ChangeDeathInfoEvent(
                                                      deathInfo: DeathInfo(
                                                          hospitalOther:
                                                              text)));
                                            }
                                          },
                                          onValidate: (String? value) {
                                            return null;
                                          }),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  )
                                : Container(),
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
                                   // isDisabled:(state.editInfoSection==false&& state.requestDetailsModel?.deceasedInfo?.deceasedDataSource=="BALADY"),
                                    isDisabled:state.isFieldDisabled(state.requestDetailsModel?.deceasedInfo?.deceasedDataSource , EditFiledActionEnum.BurialCity, null),

                                    title: ("burial_in_death_city").tr(),
                                    value: true,
                                    currentSelected: state
                                            .requestDetailsModel
                                            ?.burialInfo
                                            ?.isBurialInsideDeathCity ??
                                        true,
                                    onChange: (bool item) {

                                      context.read<EkramRequestTransportationBloc>().add(const ResetActionEvent(action:  ResetActionEnum.burialCity));

                                      context
                                          .read<
                                              EkramRequestTransportationBloc>()
                                          .add(
                                            setBurialInfoEvent(
                                              burialInfo: BurialInfo(
                                                isBurialInsideDeathCity: true,
                                              ),
                                            ),
                                          );
                                    },
                                    endRadio: false,
                                    unSelectedBackgroundColor:
                                        Colors.transparent,
                                    textSize: 16,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: CustomRadioButtonEnd<bool>(
                                    title: ("burial_in_other_city").tr(),
                                   // isDisabled:(state.editInfoSection==false&& state.requestDetailsModel?.deceasedInfo?.deceasedDataSource=="BALADY"),
                                    isDisabled:state.isFieldDisabled(state.requestDetailsModel?.deceasedInfo?.deceasedDataSource , EditFiledActionEnum.BurialCity, null),

                                    value: true,
                                    currentSelected: state
                                            .requestDetailsModel
                                            ?.burialInfo
                                            ?.isBurialInsideDeathCity ==
                                        false,
                                    onChange: (bool item) {
                                      context.read<EkramRequestTransportationBloc>().add(const ResetActionEvent(action:  ResetActionEnum.burialCity));

                                      context
                                          .read<
                                              EkramRequestTransportationBloc>()
                                          .add(setBurialInfoEvent(
                                              burialInfo: BurialInfo(
                                                  isBurialInsideDeathCity:
                                                      false,
                                                  cityId: null,
                                                  burialDestination:
                                                      "OTHER_CITY")));
                                    },
                                    endRadio: false,
                                    unSelectedBackgroundColor:
                                        Colors.transparent,
                                    textSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            state.requestDetailsModel?.burialInfo
                                        ?.isBurialInsideDeathCity ==
                                    false
                                ? CustomLookUpLongDialog(
                                   // isDisbaled:(state.editInfoSection==false&& state.requestDetailsModel?.deceasedInfo?.deceasedDataSource=="BALADY"),
                                    isDisbaled:state.isFieldDisabled(state.requestDetailsModel?.deceasedInfo?.deceasedDataSource , EditFiledActionEnum.BurialCity, null),

                              items: state.burialCities ?? [],
                                    value: state.getBurialCityById(state
                                        .requestDetailsModel
                                        ?.burialInfo
                                        ?.cityId),

                                    onEmptyList: () async {
                                      return context
                                          .read<
                                              EkramRequestTransportationBloc>()
                                          .getBurialCitiesHandler();
                                    },
                                    onChangeType: (LookUpItem? item) {
                                      if (item != null) {
                                        if (item.id != null &&
                                            state.requestDetailsModel
                                                    ?.burialInfo
                                                    ?.isCityChanged(item.id!) ==
                                                true) {
                                          context
                                              .read<
                                                  EkramRequestTransportationBloc>()
                                              .add(const ResetActionEvent(
                                                  action: ResetActionEnum
                                                      .burialCity));
                                        }
                                        context
                                            .read<
                                                EkramRequestTransportationBloc>()
                                            .add(setBurialInfoEvent(
                                                burialInfo: BurialInfo(
                                                    isBurialInsideDeathCity:
                                                        false,
                                                    cityId: item.id)));
                                      }
                                    },
                                    label: "burial_city".tr(),
                                    hint: "",
                                  )
                                : const SizedBox.shrink(),
                            BurialDateHijri(
                              currentDate: state
                                  .requestDetailsModel?.burialInfo?.burialDate,

                             // isDeathDatesDisabled:(state.editInfoSection==false&& state.requestDetailsModel?.deceasedInfo?.deceasedDataSource=="BALADY"),
                              isDeathDatesDisabled:state.isFieldDisabled(state.requestDetailsModel?.deceasedInfo?.deceasedDataSource , EditFiledActionEnum.BurialDate, state
                                  .requestDetailsModel?.burialInfo?.gregorianBurialDate),

                              onChanged: (String? date) {
                                context
                                    .read<EkramRequestTransportationBloc>()
                                    .add(setBurialInfoEvent(
                                        burialInfo: BurialInfo(
                                            burialDate:
                                                CommonFunctions.padHijriDate(
                                                    date!),
                                            gregorianBurialDate: CommonFunctions
                                                .hijriToGregorian(date))));
                              },
                            ),
                            BurialDateGorgian(
                              currentDate: state.requestDetailsModel?.burialInfo
                                  ?.gregorianBurialDate,
                             // isDeathDatesDisabled: state.isBurialDatesDisabled,
                              //isDeathDatesDisabled:(state.editInfoSection==false&& state.requestDetailsModel?.deceasedInfo?.deceasedDataSource=="BALADY"),
                              isDeathDatesDisabled:state.isFieldDisabled(state.requestDetailsModel?.deceasedInfo?.deceasedDataSource , EditFiledActionEnum.BurialDate, state
                                  .requestDetailsModel?.burialInfo?.gregorianBurialDate),
                              onChanged: (String? date) {
                                context
                                    .read<EkramRequestTransportationBloc>()
                                    .add(
                                      setBurialInfoEvent(
                                        burialInfo: BurialInfo(
                                          gregorianBurialDate:
                                              CommonFunctions.padHijriDate(
                                                  date!),
                                          burialDate:
                                              CommonFunctions.gregorianToHijri(
                                                  date),
                                        ),
                                      ),
                                    );
                              },
                            ),
                            CustomLookUpLongDialog(
                              items: state.prayers ?? [],
                             // isDisbaled:(state.editInfoSection==false&& state.requestDetailsModel?.deceasedInfo?.deceasedDataSource=="BALADY"),
                              isDisbaled:state.isFieldDisabled(state.requestDetailsModel?.deceasedInfo?.deceasedDataSource , EditFiledActionEnum.Prayer, null),

                              value: state.getParyerById(state.requestDetailsModel?.burialInfo?.prayId, state.requestDetailsModel?.burialInfo?.prayName),
                              onEmptyList: () async {
                                context
                                    .read<EkramRequestTransportationBloc>()
                                    .getPrayers();
                              },
                              onChangeType: (LookUpItem? item) {
                                if (item != null) {
                                  if (item.id != null &&
                                      state.requestDetailsModel?.burialInfo
                                              ?.isPrayerChanged(item.id!) ==
                                          true) {
                                    context
                                        .read<EkramRequestTransportationBloc>()
                                        .add(const ResetActionEvent(
                                            action: ResetActionEnum.prayer));
                                  }
                                  context
                                      .read<EkramRequestTransportationBloc>()
                                      .add(
                                        setBurialInfoEvent(
                                          burialInfo: BurialInfo(
                                            prayId: item.id,
                                          ),
                                        ),
                                      );
                                }
                              },
                              label: Helpers.translatingWord(
                                  "cemetry_deceassed_burial_time"),
                              hint: Helpers.translatingWord(
                                  "cemetry_deceassed_burial_time"),
                            ),
                            state
                                        .getPrayerById(
                                            state.requestDetailsModel
                                                ?.burialInfo?.prayId,
                                            state.requestDetailsModel
                                                ?.burialInfo?.prayName)
                                        ?.isOther ??
                                    false
                                ? TripDateTimeWidget(
                                    title: "cemetry_deceassed_burial_time".tr(),
                                    isEditable: true,
                                    showDate: false,
                                    time: state.requestDetailsModel?.burialInfo
                                                ?.burialTime !=
                                            null
                                        ? CommonFunctions.getFormattedTimeEkram(
                                            state.requestDetailsModel
                                                ?.burialInfo?.burialTime)
                                        : null,
                                    onTimeCallback: (String? time) {
                                      if (time != null) {
                                        DateTime tempTime =
                                            DateFormat("HH:mm").parse(time);
                                        String strTime = DateFormat("HH:mm")
                                            .format(tempTime)
                                            .toString();
                                        context
                                            .read<
                                                EkramRequestTransportationBloc>()
                                            .add(
                                              setBurialInfoEvent(
                                                burialInfo: BurialInfo(
                                                  burialTime: strTime,
                                                ),
                                              ),
                                            );
                                      }
                                    },
                                  )


                                : const SizedBox(),
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
                            const CustomVerticalSpace(height: 10),
                            CustomTextWidget(
                              "is_deaceased_requrie_special_transfer".tr(),
                              fontColor: AppColor.blackModern700Light,
                              fontSize: 16.0,
                              maxLines: 2,
                              textAlign: TextAlign.start,
                              fontWeight: AppFontWeight.bold,
                            ),
                            const CustomVerticalSpace(height: 10),
                            CustomRadioButtonEnd<bool>(
                              title: "yes".tr(),
                              value: true,
                              currentSelected: state.requestDetailsModel
                                      ?.transportInfo?.needSpecialTransport ==
                                  true,
                              onChange: (bool item) {
                                context
                                    .read<EkramRequestTransportationBloc>()
                                    .add(setTransportInfoEvent(
                                        transportInfo: TransportInfo(
                                            needSpecialTransport: true)));
                              },
                              endRadio: false,
                              unSelectedBackgroundColor: Colors.transparent,
                              textSize: 16,
                            ),
                            const CustomVerticalSpace(height: 10),
                            CustomRadioButtonEnd<bool>(
                              title: "no".tr(),
                              value: true,
                              currentSelected: state.requestDetailsModel
                                      ?.transportInfo?.needSpecialTransport ==
                                  false,
                              onChange: (bool item) {
                                context
                                    .read<EkramRequestTransportationBloc>()
                                    .add(setTransportInfoEvent(
                                        transportInfo: TransportInfo(
                                            needSpecialTransport: false,
                                            specialTransportReasonId: null,
                                            showOther: false)));
                              },
                              endRadio: false,
                              unSelectedBackgroundColor: Colors.transparent,
                              textSize: 16,
                            ),
                            state.requestDetailsModel?.transportInfo
                                        ?.needSpecialTransport ??
                                    false
                                ? CustomLookUpLongDialog(
                                    items: state.specialTransportReasons ?? [],
                                    value: state.getResoansTypeById(state
                                        .requestDetailsModel
                                        ?.transportInfo
                                        ?.specialTransportReasonId),
                                    onChangeType: (LookUpItem? item) {
                                      context
                                          .read<
                                              EkramRequestTransportationBloc>()
                                          .add(setTransportInfoEvent(
                                              transportInfo: TransportInfo(
                                                  specialTransportReasonId:
                                                      item?.id,
                                                  showOther: item?.isOther)));
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
                                : const SizedBox.shrink(),
                            state.requestDetailsModel?.transportInfo
                                        ?.showOther ==
                                    true
                                ? Column(
                                    children: [
                                      CustomTextFieldWidget(
                                          label:
                                              "reasonForSpecialTransfer".tr(),
                                          initialValue: state
                                              .requestDetailsModel
                                              ?.transportInfo
                                              ?.specialTransportReasonOther,
                                          hintText:
                                              "reasonForSpecialTransfer".tr(),
                                          onChanged: (String? text) {
                                            if (text != null) {
                                              context
                                                  .read<
                                                      EkramRequestTransportationBloc>()
                                                  .add(setTransportInfoEvent(
                                                      transportInfo: TransportInfo(
                                                          specialTransportReasonOther:
                                                              text)));
                                            }
                                          },
                                          onValidate: (String? value) {
                                            return null;
                                          }),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  )
                                : Container(),
                            CustomLookUpLongDialog(
                              //isDisbaled:(state.editInfoSection==false&& state.requestDetailsModel?.deceasedInfo?.deceasedDataSource=="BALADY"),
                              isDisbaled:state.isFieldDisabled(state.requestDetailsModel?.deceasedInfo?.deceasedDataSource , EditFiledActionEnum.GraveType, null),

                              items: state.cemetryTypeItems ?? [],
                              value: state.getCemtryTypeById(
                                  state.requestDetailsModel?.cemeteryData
                                      ?.graveTypeId,
                                  state.requestDetailsModel?.cemeteryData
                                      ?.graveTypeName),
                              onEmptyList: () async {
                                return context
                                    .read<EkramRequestTransportationBloc>()
                                    .getCemetryTypeItemsHandler();
                              },
                              onChangeType: (LookUpItem? item) {
                                if (item != null) {
                                  if (item.id != null &&
                                      state.requestDetailsModel?.cemeteryData
                                              ?.isGraveTypeChanged(item.id!) ==
                                          true) {
                                    context
                                        .read<EkramRequestTransportationBloc>()
                                        .add(const ResetActionEvent(
                                            action: ResetActionEnum.GraveType));
                                  }
                                  context
                                      .read<EkramRequestTransportationBloc>()
                                      .add(setCemtryInfoEvent(
                                          cemeteryData: CemeteryData(
                                              graveTypeId: item.id)));
                                }
                              },
                              label: ("cemetry_type").tr(),
                              hint: ("cemetry_type").tr(),
                            ),


                            CustomLookUpLongDialog(
                              items: state.cemetries ?? [],
                              //isDisbaled:(state.editInfoSection==false&& state.requestDetailsModel?.deceasedInfo?.deceasedDataSource=="BALADY"),
                              isDisbaled:state.isFieldDisabled(state.requestDetailsModel?.deceasedInfo?.deceasedDataSource , EditFiledActionEnum.Cemetry, state
                                  .requestDetailsModel?.burialInfo?.gregorianBurialDate),

                              value: state.getCemtryById(
                                  state.requestDetailsModel?.cemeteryData
                                      ?.cemeteryId,
                                  state.requestDetailsModel?.cemeteryData
                                      ?.cemeteryName),
                              onEmptyList: () async {
                                context
                                    .read<EkramRequestTransportationBloc>()
                                    .add(
                                      GetCemetriesEvent(
                                        params: CemetriesParams(
                                          deathCountryId: state
                                              .requestDetailsModel
                                              ?.deathInfo
                                              ?.countryId,
                                          deathCityId:
                                              state.getselectedDeathCity(),
                                          burialCityId: state
                                              .requestDetailsModel
                                              ?.burialInfo
                                              ?.cityId,
                                          specialTransportReasonId: state
                                              .requestDetailsModel
                                              ?.transportInfo
                                              ?.specialTransportReasonId,
                                          prayId: state.requestDetailsModel
                                              ?.burialInfo?.prayId,
                                          burialTime: state.requestDetailsModel
                                              ?.burialInfo?.burialTime,
                                          burialDate: state.requestDetailsModel
                                              ?.burialInfo?.burialDate,
                                          deathDate: state.requestDetailsModel
                                              ?.deathInfo?.deathDate,
                                          graveTypeId: state.requestDetailsModel
                                              ?.cemeteryData?.graveTypeId,
                                          age: null,
                                        ),
                                        requestId: state.requestId!,
                                      ),
                                    );
                              },
                              onChangeType: (LookUpItem? item) {
                                if (item != null) {

                                  if (item.id != null &&
                                      state.requestDetailsModel?.cemeteryData
                                          ?.isCemtryChanged(item.id!) ==
                                          true) {
                                    context
                                        .read<EkramRequestTransportationBloc>()
                                        .add(const ResetActionEvent(
                                        action: ResetActionEnum.Cemetry));
                                  }

                                  context
                                      .read<EkramRequestTransportationBloc>()
                                      .add(setCemtryInfoEvent(
                                          cemeteryData:
                                              CemeteryData(cemeteryId: item.id),
                                          maghsalaExist: item.maghsalaExist));
                                }
                              },
                              label: ("cemeteryName").tr(),
                              hint: ("cemeteryName").tr(),
                            ),
                            NotesWidget(notes: ["ekram_cemetry_note".tr()]),
                            CustomLookUpLongDialog(
                              items: state.transportations ?? [],
                              value: state.getTransportTypeById(
                                  state.requestDetailsModel?.transportInfo
                                      ?.charityId,
                                  state.requestDetailsModel?.transportInfo
                                      ?.charityName),
                              onEmptyList: () async {
                                context
                                    .read<EkramRequestTransportationBloc>()
                                    .add(GetTransportationNamesEvent(
                                        params: TransportationCompaniesParams(
                                            cemeteryId: state
                                                .requestDetailsModel
                                                ?.cemeteryData
                                                ?.cemeteryId,
                                            deathCityId: state
                                                .requestDetailsModel
                                                ?.deathInfo
                                                ?.cityId),
                                        requestId: state.requestId!));
                              },
                              onChangeType: (LookUpItem? item) {
                                if (item != null) {
                                  if (item.id != null &&
                                      state.requestDetailsModel?.transportInfo
                                          ?.isCharityChanged(item.id!) ==
                                          true) {
                                    context
                                        .read<EkramRequestTransportationBloc>()
                                        .add(const ResetActionEvent(
                                        action: ResetActionEnum.Transport));
                                  }

                                  context
                                      .read<EkramRequestTransportationBloc>()
                                      .add(setTransportInfoEvent(
                                          transportInfo: TransportInfo(
                                              charityId: item.id)));
                                }
                              },
                              label: ("ekram_orgnization_name").tr(),
                              hint: ("ekram_orgnization_name").tr(),
                            ),
                            NotesWidget(notes: ["ekram_org_note".tr()]),
                            CustomLookUpLongDialog(
                              showOptional:
                                  state.maghsalaExist == true ? true : false,
                              items: state.laundries ?? [],
                              value: state.getlaundriesById(
                                  state.requestDetailsModel?.transportInfo
                                      ?.ghuslPlaceId,
                                  state.requestDetailsModel?.transportInfo
                                      ?.ghuslPlaceName),
                              onEmptyList: () async {
                                context
                                    .read<EkramRequestTransportationBloc>()
                                    .add(GetLandriesEvent(
                                        params: MosqueGhuslPlacesParams(
                                            burialDate: state
                                                .requestDetailsModel
                                                ?.burialInfo
                                                ?.burialDate,
                                            gender: state.requestDetailsModel
                                                ?.deceasedInfo?.gender),
                                        cityIds: [
                                          state.requestDetailsModel?.deathInfo
                                              ?.cityId,
                                          state.requestDetailsModel?.burialInfo
                                              ?.cityId
                                        ],
                                        transportId: state.requestDetailsModel
                                            ?.transportInfo?.charityId));
                              },
                              onChangeType: (LookUpItem? item) {
                                if (item != null) {
                                  context
                                      .read<EkramRequestTransportationBloc>()
                                      .add(setTransportInfoEvent(
                                          transportInfo: TransportInfo(
                                              ghuslPlaceId: item.id)));
                                }
                              },
                              label: ("ekram_laundry").tr(),
                              hint: ("ekram_laundry").tr(),
                            ),
                            NotesWidget(notes: ["ekram_laundry_note".tr()]),
                            CustomLookUpLongDialog(
                              showOptional: true,
                              items: state.mosques ?? [],
                              value: state.getMosquesById(
                                  state.requestDetailsModel?.transportInfo
                                      ?.mosqueId,
                                  state.requestDetailsModel?.transportInfo
                                      ?.mosqueName),
                              onEmptyList: () async {
                                context
                                    .read<EkramRequestTransportationBloc>()
                                    .add(GetMosquesEvent(
                                        ghuslplace: MosqueGhuslPlacesParams(
                                            burialDate: state
                                                .requestDetailsModel
                                                ?.burialInfo
                                                ?.burialDate,
                                            gender: state.requestDetailsModel
                                                ?.deceasedInfo?.gender),
                                        cityIds: [
                                          state.requestDetailsModel?.deathInfo
                                              ?.cityId,
                                          state.requestDetailsModel?.burialInfo
                                              ?.cityId
                                        ],
                                        transportId: state.requestDetailsModel
                                            ?.transportInfo?.charityId));
                              },
                              onChangeType: (LookUpItem? item) {
                                if (item != null) {
                                  context
                                      .read<EkramRequestTransportationBloc>()
                                      .add(setTransportInfoEvent(
                                          transportInfo: TransportInfo(
                                              mosqueId: item.id)));
                                }
                              },
                              label: ("the_mosque").tr(),
                              hint: ("the_mosque").tr(),
                            ),
                            NotesWidget(notes: ["ekram_mosque_note".tr()]),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                context
                    .read<EkramRequestTransportationBloc>()
                    .add(const saveBurianDeathInfoEvent(isDarft: true));
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: AppColor.borderBlck, width: 1),
                    borderRadius: BorderRadius.circular(6)),
                //:BoxDecoration(color: AppColor.blackModern300Light.withOpacity(0.4), borderRadius: BorderRadius.circular(8)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomTextWidget(
                      "SaveAsDraft".tr(),
                      fontSize: 14,
                      fontWeight: AppFontWeight.bold,
                      fontColor: AppColor.borderBlck,
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
            ),
            EkramPreviousNextButtons(
              btnPressed: () {
                if (state.validateDeathAndBurialInfoSection(true) == true) {
                  context
                      .read<EkramRequestTransportationBloc>()
                      .add(const saveBurianDeathInfoEvent());
                }
              },
            )
          ],
        );
      },
    );
  }
}
