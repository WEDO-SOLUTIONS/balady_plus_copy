import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_advisor/app/core/utils/constants/app_colors.dart';
import 'package:smart_advisor/app/core/utils/constants/app_style.dart';
import 'package:smart_advisor/app/core/utils/utils_exports.dart';
import 'package:smart_advisor/app/features/_shared_feature_/presentation/widgets/custom_widgets/customTextField.dart';
import 'package:smart_advisor/app/features/manage_license_flow/data/model/license_model.dart';
import 'package:smart_advisor/app/features/manage_license_flow/presentation/blocs/main_flow_bloc/main_flow_bloc.dart';
import 'package:smart_advisor/app/features/manage_license_flow/presentation/widgets/option_license_card.dart';

class RenweLicensePageUser extends StatefulWidget {
  const RenweLicensePageUser({super.key});

  @override
  State<RenweLicensePageUser> createState() => _RenweLicensePageUserState();
}

class _RenweLicensePageUserState extends State<RenweLicensePageUser> {
  int _selectedIndex = -1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    context
        .read<ManageMainFlowBloc>()
        .add(const GetLicensesEvent(licenseType: "1004"));
  }

  String query = "";

  @override
  Widget build(BuildContext context) {
    /* List<LicenseCardModel> dataList = const [
      LicenseCardModel(
        idNumber: "374938473",
        status: "سارية",
        isAcitve: true,
        title: "رخصة محل",
        subTitle: "الاسم التجاري",
        branchName: "بلدية العليا",
        city: "أمانة الرياض",
        date: "2024/2/4",
      ),
      LicenseCardModel(
        idNumber: "374938473",
        status: "سارية",
        isAcitve: true,
        title: "رخصة عربة",
        branchName: "بلدية العليا",
        city: "أمانة الرياض",
        date: "2024/2/4",
      ),
      LicenseCardModel(
        idNumber: "374938473",
        status: "قاربت على الاإنتهاء ",
        isAcitve: false,
        title: "رخصة محل",
        branchName: "بلدية العليا",
        city: "أمانة الرياض",
        date: "2024/2/4",
      ),
    ];*/

    return BlocBuilder<ManageMainFlowBloc, ManageMainFlowState>(
      builder: (context, state) {
        List<LicensesResponseItem>? licenses = state.licenses ?? [];
        licenses = licenses
            .map((e) {
              if (e.licenseNo.toString().contains(query)) return e;
            })
            .nonNulls
            .toList();

        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(top: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "ما الرخصة التي ترغب في تجديدها؟",
                            style: AppStyle.somarSemiBold
                                .copyWith(color: AppColor.textPrimaryColor),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            "تعرض القائمة الرخص المدرجة تحت السجل ",
                            style: AppStyle.textRegularStyle
                                .copyWith(color: AppColor.textSecondaryColor),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          // Search
                          Textfield(
                            isDigit: true,
                            onChanged: (String? t) {
                              setState(() {
                                query = t ?? "";
                              });
                            },
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          if ((licenses?.isEmpty ?? true) &&
                              state.licenseStatus == BlocStatus.success)
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "packages/smart_advisor/smart_advisor_assets/images/searchimg.png",
                                    height: 122,
                                    width: 150,
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    "لا يوجد",
                                    textAlign: TextAlign.center,
                                    style: AppStyle.textRegularRomanStyle
                                        .copyWith(
                                            color: const Color(0xFF566069)),
                                  ),
                                ],
                              ),
                            ),
                          MediaQuery.removePadding(
                            removeTop: true,
                            context: context,
                            child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: licenses.length ?? 0,
                              itemBuilder: (context, index) {
                                return OptionLicenseCard(
                                    isCommercialRegister: false,
                                    data: LicenseCardModel(
                                      idNumber: licenses?[index]
                                              .licenseNo
                                              .toString() ??
                                          "",
                                      status:
                                          licenses?[index].licenseStatusName ??
                                              "",
                                      isAcitve: false,
                                      title: licenses?[index].shopName ?? "",
                                      branchName: licenses?[index]
                                              .subMunicipalityName ??
                                          "",
                                      city: licenses?[index].municipalityName ??
                                          "",
                                      date:
                                          licenses?[index].licenseEndDate ?? "",
                                    ),
                                    isSelected: _selectedIndex == index,
                                    onTap: () {
                                      context.read<ManageMainFlowBloc>().add(
                                          SelectLicenseEvent(
                                              license: licenses![index]));
                                      setState(() {
                                        _selectedIndex = index;
                                      });

                                      // context
                                      //     .read<ManageMainFlowBloc>()
                                      //     .add(const ChangeValueEvent(
                                      //       currentPagesNumber: 1,
                                      //       isLastCancelPage: true,
                                      //     ));
                                    });
                              },
                            ),
                          ),

                          if (state.licenseStatus == BlocStatus.loading)
                            Center(
                              child: CircularProgressIndicator(
                                color: AppColor.statusAccentColor,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
