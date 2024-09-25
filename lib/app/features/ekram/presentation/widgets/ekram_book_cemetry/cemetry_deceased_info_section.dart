import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/notes_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/services/local/helpers.dart';
import '../../../../_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_cupertino_drop_down_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/radio_buttons/custom_check_box_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/texts/custom_text_field_widget.dart';
import '../../../../new_appointment/presentation/core/models/lookup_list_model.dart';
import '../../../../vd/presentation/widgets/vd_header_desc_widget.dart';
import '../../blocs/ekram_book_cemetry/ekram_book_cemetry_bloc.dart';
import 'cemetry_burial_date_gorgian.dart';
import 'cemetry_burial_date_hijri.dart';
import 'cemetry_is_epidamic_widget.dart';
import 'cemetry_national_id_date_gorgian.dart';
import 'cemetry_national_id_date_hijri.dart';
import 'cemetry_previous_next_buttons.dart';
import 'dead_fetus.dart';
import 'dead_gender.dart';
import 'dead_religion.dart';

import 'deceased_info_widget.dart';

class CemetryDeceasedInfoSection extends StatefulWidget {
  const CemetryDeceasedInfoSection({Key? key}) : super(key: key);

  @override
  State<CemetryDeceasedInfoSection> createState() =>
      _CemetryDeceasedInfoSectionState();
}

class _CemetryDeceasedInfoSectionState
    extends State<CemetryDeceasedInfoSection> {
  // final otherHospitalTextEditController = TextEditingController();
  //final otherHospitalShipFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    // var bloc = context.watch<EkramBookCemetryBloc>();
    // if (bloc.state.burialDateGorgian == null) {
    //   bloc.add(
    //     ChangeBurialDateEvent(
    //       gorgianDate: DateFormat('yyyy/MM/dd').format(
    //         DateTime.now(),
    //       ),
    //     ),
    //   );
    // }
  }

  @override
  void dispose() {
    super.dispose();
  }

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
                  margin: const EdgeInsets.only(top: 24, left: 16, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      VdHeaderDesc(
                        header:
                            Helpers.translatingWord("cemetry_deceassed_info"),
                      ),
                      const DeadFetusWidget(),
                      if (state.isFetus == false)
                        CustomLookUpLongDialog(
                          items: state.nationalTypes ?? [],
                          value: state.selectedNationalType,
                          onEmptyList: () async {
                            return context
                                .read<EkramBookCemetryBloc>()
                                .getNationalTypesHandler();
                          },
                          onChangeType: (LookUpItem? item) {
                            print(item?.name);
                            if (item != null) {
                              context
                                  .read<EkramBookCemetryBloc>()
                                  .add(ChangeNationalType(item: item));
                            }
                          },
                          label:
                              "${Helpers.translatingWord("cemetry_national_type")} *",
                          hint:
                              Helpers.translatingWord("cemetry_national_type"),
                        ),
                      if (state.isFetus == false)
                        CustomTextFieldWidget(
                            label:
                                "${Helpers.translatingWord("cemetry_national_id")} *",
                            hintText:
                                Helpers.translatingWord("cemetry_national_id"),
                            initialValue: state.deceassedId,
                            // controller: otherHospitalTextEditController,
                            //  focusNode: otherHospitalShipFocusNode,
                            maxLines: 1,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.number,
                            onChanged: (String? text) {
                              context
                                  .read<EkramBookCemetryBloc>()
                                  .add(ChangeNationalId(text: text));
                            },
                            onValidate: (String? value) {
                              return context
                                  .read<EkramBookCemetryBloc>()
                                  .validateNationalId(value);
                            }),
                      const CustomVerticalSpace(
                        height: 16,
                      ),
                      if (state.isFetus == false) ...[
                        const CemetryNationalDobHijri(),
                        const CemetryNationalDobGorgian(),
                        // if (state.selectedNationalType?.fillInfo == false)
                        ElevatedButtonWidget.verify(
                            text: (state.userInfoResponse != null)
                                ? "done_check".tr()
                                : "verify".tr(),
                            onPressed: () {
                              context
                                  .read<EkramBookCemetryBloc>()
                                  .add(const CheckUserInfoEvent());
                            }),
                        const CustomVerticalSpace(height: 16),
                      ],
                      ...[
                        CustomTextFieldWidget(
                            label:
                                "${Helpers.translatingWord("ekram_first_name")} *",
                            hintText:
                                Helpers.translatingWord("ekram_first_name"),
                            controller: context
                                .read<EkramBookCemetryBloc>()
                                .firstNameController,
                            enabled: state.allowFillData() &&
                                !state.isdeceasedInfoReadOnly,
                            onChanged: (String? text) {
                              context
                                  .read<EkramBookCemetryBloc>()
                                  .add(ChangeNameEvent(firstName: text));
                            },
                            onValidate: (String? value) {
                              return null;
                            }),
                        const CustomVerticalSpace(height: 16),
                        CustomTextFieldWidget(
                            label: Helpers.translatingWord("ekram_second_name"),
                            hintText:
                                Helpers.translatingWord("ekram_second_name"),
                            controller: context
                                .read<EkramBookCemetryBloc>()
                                .secondNameController,
                            enabled: state.allowFillData() &&
                                !state.isdeceasedInfoReadOnly,
                            onChanged: (String? text) {
                              context
                                  .read<EkramBookCemetryBloc>()
                                  .add(ChangeNameEvent(secondName: text));
                            },
                            onValidate: (String? value) {
                              return null;
                            }),
                        const CustomVerticalSpace(height: 16),
                        CustomTextFieldWidget(
                            label: Helpers.translatingWord("ekram_third_name"),
                            hintText:
                                Helpers.translatingWord("ekram_third_name"),
                            controller: context
                                .read<EkramBookCemetryBloc>()
                                .thirdNameController,
                            enabled: state.allowFillData() &&
                                !state.isdeceasedInfoReadOnly,
                            onChanged: (String? text) {
                              context
                                  .read<EkramBookCemetryBloc>()
                                  .add(ChangeNameEvent(thirdName: text));
                            },
                            onValidate: (String? value) {
                              return null;
                            }),
                        const CustomVerticalSpace(height: 16),
                        CustomTextFieldWidget(
                            label:
                                "${Helpers.translatingWord("ekram_fourth_name")} *",
                            hintText:
                                Helpers.translatingWord("ekram_fourth_name"),
                            enabled: state.allowFillData() &&
                                !state.isdeceasedInfoReadOnly,
                            controller: context
                                .read<EkramBookCemetryBloc>()
                                .fourthNameController,
                            onChanged: (String? text) {
                              context
                                  .read<EkramBookCemetryBloc>()
                                  .add(ChangeNameEvent(fourthName: text));
                            },
                            onValidate: (String? value) {
                              return null;
                            }),
                      ],
                      /*if (state.userInfoResponse != null)
                        DeceassedInfoWidget(
                          gender: state.userInfoResponse?.genderDescription,
                          name: state.userInfoResponse?.fullName,
                          religion: state.userInfoResponse?.religionDescription,
                          nationality:
                              state.userInfoResponse?.nationalityDescription,
                        ),*/
                      const CustomVerticalSpace(height: 16),
                      CustomLookUpLongDialog(
                        isDisbaled: state.isdeceasedInfoReadOnly,
                        items: state.nationalities ?? [],
                        value: state.selectedNationality,
                        onEmptyList: () async {
                          return context
                              .read<EkramBookCemetryBloc>()
                              .getNationalities();
                        },
                        onChangeType: (LookUpItem? item) {
                          if (item != null) {
                            context
                                .read<EkramBookCemetryBloc>()
                                .add(GetNationalityEvent(item: item));
                          }
                        },
                        label: "${("nationality").tr()} *",
                        hint: ("nationality").tr(),
                      ),
                      const CustomVerticalSpace(height: 16),
                      const DeadReligionWidget(),
                      const CustomVerticalSpace(height: 16),
                      const DeadGenderWidget(),
                      const CustomVerticalSpace(height: 16),
                      CustomLookUpLongDialog(
                        isDisbaled: state.deceasedInfoModel?.deceasedDataSource == 'SEHA' ,
                        items: state.countries ?? [],
                        value: state.selectedCountry,
                        onEmptyList: () async {
                          return context
                              .read<EkramBookCemetryBloc>()
                              .getCountries();
                        },
                        onChangeType: (LookUpItem? item) {
                          print(item?.name);
                          if (item != null) {
                            context
                                .read<EkramBookCemetryBloc>()
                                .add(ChangeCountryEvent(item: item));
                          }
                        },
                        label:
                            "${Helpers.translatingWord("ekram_death_country")} *",
                        hint: Helpers.translatingWord("ekram_death_country"),
                      ),
                      if (state.selectedCountry?.localCountry == true)
                        CustomLookUpLongDialog(
                          isDisbaled: state.deceasedInfoModel?.deceasedDataSource == 'SEHA' ,
                          items: state.deathCities ?? [],
                          value: state.selectedDeathCity,
                          onEmptyList: () async {
                            return context
                                .read<EkramBookCemetryBloc>()
                                .getDeathCities();
                          },
                          onChangeType: (LookUpItem? item) {
                            print(item?.name);
                            if (item != null) {
                              context
                                  .read<EkramBookCemetryBloc>()
                                  .add(ChangeDeathCityEvent(item: item));
                            }
                          },
                          label:
                              "${Helpers.translatingWord("ekram_death_city")} *",
                          hint: Helpers.translatingWord("ekram_death_city"),
                        ),
                      if (state.selectedCountry?.localCountry == false)
                        CustomTextFieldWidget(
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r"[a-zA-Z\u0621-\u064A]")),
                            ],
                            keyboardType: TextInputType.name,
                            label:
                                "${Helpers.translatingWord("ekram_death_city")} *",
                            hintText:
                                Helpers.translatingWord("ekram_death_city"),
                            initialValue: state.otherDeathCity,
                            maxLines: 1,
                            onChanged: (String? text) {
                              context
                                  .read<EkramBookCemetryBloc>()
                                  .add(ChangeOtherCityEvent(text: text));
                            },
                            onValidate: (String? value) {
                              return null;
                            }),
                      const CustomVerticalSpace(height: 16),
                      CustomLookUpLongDialog(
                        items: state.cities ?? [],
                        value: state.selectedCity,
                        onEmptyList: () async {
                          return context
                              .read<EkramBookCemetryBloc>()
                              .getCitiesHandler();
                        },
                        onChangeType: (LookUpItem? item) {
                          print(item?.name);
                          if (item != null) {
                            context
                                .read<EkramBookCemetryBloc>()
                                .add(ChangeBurialCityEvent(item: item));
                          }
                        },
                        label:
                            "${Helpers.translatingWord("cemetry_deceassed_burial_city")} *",
                        hint: Helpers.translatingWord(
                            "cemetry_deceassed_burial_city"),
                      ),
                      const CemetryBurialDateHijri(),
                      const CemetryBurialDateGorgian(),
                      CustomLookUpLongDialog(
                        items: state.burialTimeItems ?? [],
                        value: state.selectedTime,
                        onEmptyList: () async {
                          return context
                              .read<EkramBookCemetryBloc>()
                              .getBurialTimesItemsHandler();
                        },
                        onChangeType: (LookUpItem? item) {
                          if (item != null) {
                            context
                                .read<EkramBookCemetryBloc>()
                                .add(ChangeBurialTimevent(item: item));
                          }
                        },
                        label:
                            "${Helpers.translatingWord("cemetry_deceassed_burial_time")} *",
                        hint: Helpers.translatingWord(
                            "cemetry_deceassed_burial_time"),
                      ),
                      if (state.selectedTime?.id == 30976)
                        CustomHeaderAndDescOnTapWidget(
                            label: Helpers.translatingWord(
                                "cemetry_deceassed_burial_time"),
                            hintText: state.otherTimeName == null
                                ? Helpers.translatingWord(
                                    "cemetry_deceassed_burial_time")
                                : state.otherTimeName ?? "",
                            onTap: () {
                              context
                                  .read<EkramBookCemetryBloc>()
                                  .add(ChangeBurialTimeOtherNameEvent());
                            }),
                      const CemetryIsEpidamicWidget(),
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
                        label: "${("cemetry_type").tr()} *",
                        hint: ("cemetry_type").tr(),
                      ),
                      NotesWidget(notes: ["cemeteries_displayed".tr()]),
                      CustomLookUpLongDialog(
                        items: state.cemetries ?? [],
                        value: state.selectedCemetry,
                        onEmptyList: () async {
                          return context
                              .read<EkramBookCemetryBloc>()
                              .getCemetriesHandler();
                        },
                        onChangeType: (LookUpItem? item) {
                          if (item != null) {
                            context
                                .read<EkramBookCemetryBloc>()
                                .add(ChangeCemetryEvent(item: item));
                          }
                        },
                        label: "${Helpers.translatingWord("cemetry_name")} *",
                        hint: Helpers.translatingWord("cemetry_name"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            CemetryreviousNextButtons(
              isBtnDisabled: !state.isNextButtonEnabled(),
              onPressed: () {
                context.read<EkramBookCemetryBloc>().add(GoToNextPageEvent());
              },
            )
          ],
        );
      },
    );
  }
}
