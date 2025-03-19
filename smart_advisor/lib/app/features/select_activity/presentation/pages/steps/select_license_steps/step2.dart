import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_advisor/app/core/utils/constants/app_colors.dart';
import 'package:smart_advisor/app/core/utils/constants/app_style.dart';
import 'package:smart_advisor/app/features/_shared_feature_/presentation/widgets/custom_widgets/customTextField.dart';
import 'package:smart_advisor/app/features/manage_license_flow/data/model/license_model.dart';
import 'package:smart_advisor/app/features/manage_license_flow/presentation/widgets/option_license_card.dart';

import '../../../../../../core/utils/enums/bloc_status.dart';
import '../../../blocs/main_flow_bloc/main_flow_bloc.dart';

class SelectLicenseStep extends StatefulWidget {
  const SelectLicenseStep({super.key});

  @override
  State<SelectLicenseStep> createState() => _SelectLicenseStepState();
}

class _SelectLicenseStepState extends State<SelectLicenseStep> {
  int _selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    context.read<MainFlowBloc>().add(GetLicensesEvent(licenseType: "1004"));
  }

  String query = "";

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainFlowBloc, MainFlowState>(
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
                            "ما الرخصة التي ترغب في تقييمها",
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
                                      context.read<MainFlowBloc>().add(
                                          SelectLicenseEvent(
                                              license: licenses![index]));
                                      setState(() {
                                        _selectedIndex = index;
                                      });
                                    });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (state.licenseStatus == BlocStatus.loading ||
                      state.licenseDetailsStatus == BlocStatus.loading ||
                      state.licenseDetailsStatus == BlocStatus.loading)
                    Center(
                      child: CircularProgressIndicator(
                        color: AppColor.statusAccentColor,
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
