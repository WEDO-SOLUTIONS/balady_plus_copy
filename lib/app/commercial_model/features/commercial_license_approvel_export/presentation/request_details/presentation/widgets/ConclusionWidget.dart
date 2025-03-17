import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/constants.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';

import '../../../../../../../core/utils/constants/app_style.dart';
import '../../../../../../../core/utils/constants/remote_config.dart';
import '../../../../../../../core/utils/enums/bloc_status.dart';
import '../../../../../../../features/_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../../../../../../features/_shared_feature_/presentation/widgets/reload_widget.dart';
import '../../../../domain/entities/conclusion_section.dart';
import '../../bloc/commercial_license_details_bloc.dart';
import 'Fees.dart';




class ConclusionWidget extends StatefulWidget {


  const ConclusionWidget({super.key});

  @override
  State<ConclusionWidget> createState() => _ConclusionWidgetState();
}

class _ConclusionWidgetState extends State<ConclusionWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if( context.read<CommercialLicenseDetailsBloc>().state.issueCommercialConculsionEntity == null) {
      context.read<CommercialLicenseDetailsBloc>().getConclusion();
    }
  }
  @override
  Widget build(BuildContext context) {

    return BlocConsumer<CommercialLicenseDetailsBloc, CommercialLicenseDetailsState>(
        listener: (context, state) {

        }, builder: (context, state) {
      return Container(
        color: AppColor.scaffoldBackground,
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [

            (state.status == BlocStatus.failure)?
            ReloadWidget(
              onTab: () {
                context.read<CommercialLicenseDetailsBloc>().getConclusion();
              },):Container(),


            (state.status == BlocStatus.success)?
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [

                ExpansionSectionItem(term: context.read<CommercialLicenseDetailsBloc>().getConclusionSection(lstPreDefinedConditionsByType:state.issueCommercialConculsionEntity?.lstPreDefinedConditionsByType),),

                ExpansionSectionItem(term:ConclusionSection(sectionContent:ConSectionContent(label: "municipalAdvisorBoardsRequirements".tr(),value: [  "${RemoteConfig.baladyBaseUrl}/LicenseStandard/Default?sid=7010"]) ,sectionName: "municipalAdvisorBoardsRequirements".tr()),isUnderLine: true,),
                ExpansionSectionItem(term:ConclusionSection(sectionContent:ConSectionContent(label: "Viewmunicipalrequirements".tr(),value: [  "${RemoteConfig.baladyBaseUrl}/LicenseStandard/Default?sid=7010"]) ,sectionName: "Viewmunicipalrequirements".tr()),isUnderLine: true,),


                ExpansionSectionItem(term: context.read<CommercialLicenseDetailsBloc>().getConclusionSection(allowedPermits:state.issueCommercialConculsionEntity?.allowedPermits),note: "premits_limit".tr(),),
                ExpansionSectionItem(term: context.read<CommercialLicenseDetailsBloc>().getConclusionSection(civilDefenseDocuments:state.issueCommercialConculsionEntity?.civilDefenseAllowedDocuments),),
                ExpansionSectionItem(term: context.read<CommercialLicenseDetailsBloc>().getConclusionSection(lstSupervisingAuthorities:state.issueCommercialConculsionEntity?.supervisingAuthoritiesForActivities),),

                ExpansionSectionItem(term: context.read<CommercialLicenseDetailsBloc>().getConclusionSection(cleaningOptions:state.issueCommercialConculsionEntity?.cleaningOptions),),
               // ExpansionSectionItem(term: context.read<CommercialLicenseDetailsBloc>().getConclusionSection(preDefinedConditionTypes:state.issueCommercialConculsionEntity?.preDefinedConditionTypes),),

                OfficeExpansionSectionItem(term: context.read<CommercialLicenseDetailsBloc>().getConclusionSection(engOffices:state.issueCommercialConculsionEntity?.engOffices),),
                OfficeExpansionSectionItem(term: context.read<CommercialLicenseDetailsBloc>().getConclusionSection(commercialOffices:state.issueCommercialConculsionEntity?.commercialOffices),),
                OfficeExpansionSectionItem(term: context.read<CommercialLicenseDetailsBloc>().getConclusionSection(lstboardContractRequirementMessage:state.issueCommercialConculsionEntity?.lstboardContractRequirementMessage),),

                ExpansionSectionItem(term: context.read<CommercialLicenseDetailsBloc>().getConclusionSection(lstFastFlowConditions:state.issueCommercialConculsionEntity?.lstFastFlowConditions),),


                state.issueCommercialConculsionEntity?.calculateStandardFees != null?
                // CustomExpansionPanelWidget(
                //     title:"fee_calculator_license".tr(),
                //     leading: SvgPicture.asset(IconPath.serviceCardDesc),
                //     children: [FeesWidget(),]
                // )
                FeesWidget():Container(),
                const SizedBox(height: 15,),




              ],
            ):Container(),



            (state.status == BlocStatus.loading)
                ? const Center(child: CustomCircularLoadingWidget()):Container(),



          ],
        ),
      );


    });




  }
}



class ExpansionSectionItem extends StatelessWidget {
  final ConclusionSection? term;
  final String? note;
  final bool? isUnderLine;

  const ExpansionSectionItem({super.key, required this.term,this.note,this.isUnderLine});

  @override
  Widget build(BuildContext context) {
    return term != null?
    Column(
      children: [

        ConditionItem(name:  term!.sectionName, values:  term?.sectionContent?.value ?? [],note: note,isUnderLine: isUnderLine,),
        const SizedBox(height: 15,),
      ],
    ):Container();
  }
}

class ConditionItem extends StatelessWidget {
  final String? name;
  final String? note;
  final List<String>? values;
  final bool? isUnderLine;
  const ConditionItem({super.key, this.name, this.values,this.note,this.isUnderLine});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
          color: Color(0x80E6EFEF),
          borderRadius: BorderRadius.all(Radius.circular(8))),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          note != null?NotesWidget(notes: [note!],marginBottom: 10,):Container(),


          if (name != null && name!.isNotEmpty)
            CustomTextWidget(
              name!,
              fontColor: AppColor.primary700Light,
              fontSize: 12,
              fontWeight: AppFontWeight.bold,
            ),
          if (name != null && name!.isNotEmpty)
            const CustomVerticalSpace(height: 4),


          ((values?.length ?? 0) <= 1)?

          isUnderLine==true? Text.rich(
            TextSpan(
              text: name,
              style: AppStyle.lightTextStyle.copyWith(
                decoration: TextDecoration.underline,
                fontSize: 15,
                color: AppColor.blue
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  CommonFunctions.externalLaunch(
                    "${RemoteConfig.baladyBaseUrl}/LicenseStandard/Default?sid=7010",

                  );
                },
            ),
          ):

            Html(
              data: values?.firstOrNull ?? "",
              style: {
                "body": Style(
                    fontSize: FontSize(14.0),
                    fontWeight: FontWeight.bold,
                    color: AppColor.blackModern700Light,
                    // lineHeight: const LineHeight(2),
                    fontFamily: Constants.appFontType),
              },
              onLinkTap: (url, attributes, element) {
                CommonFunctions.openBaladyWebView(url);
              },

            ):Container(),
          if ((values?.length ?? 0) > 1)
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: values?.length ?? 0,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(IconPath.checked),
                          const CustomHorizontalSpace(width: 4),
                          Flexible(
                            child: Html(
                              data: values?[index] ?? "",
                              style: {
                                "body": Style(
                                    fontSize: FontSize(14.0),
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.blackModern700Light,
                                    //   lineHeight: const LineHeight(2),
                                    fontFamily: Constants.appFontType),
                              },
                              onLinkTap: (url, attributes, element) {
                                CommonFunctions.openBaladyWebView(url);
                              },
                            ),
                          ),
                        ],
                      ),

                      // const CustomVerticalSpace(height: 8)
                    ],
                  );
                }),
        ],
      ),
    );
  }
}


class OfficeExpansionSectionItem extends StatelessWidget {
  final ConclusionSection? term;

  const OfficeExpansionSectionItem({super.key, required this.term});

  @override
  Widget build(BuildContext context) {
    return term != null?Column(
      children: [

        CustomExpansionPanelWidget(
          title: term?.sectionName,
          leading: SvgPicture.asset(IconPath.serviceCardDesc),
          children: [OfficeItem(values:  term?.sectionContent?.offices ?? [])]
          ,
        ),
        const SizedBox(height: 15,),
      ],
    ):Container();
  }


}

class OfficeItem extends StatelessWidget {

  final List<OfficeSection>? values;
  const OfficeItem({super.key, this.values});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: values?.length ?? 0,
            itemBuilder: (context, index) {
              return Container(
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                    color: Color(0x80E6EFEF),
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const CustomVerticalSpace(height: 15),
                    CustomTextWidget(
                      "officeName".tr(),
                      fontColor: AppColor.primary700Light,
                      fontSize: 14,
                      fontWeight: AppFontWeight.bold,
                    ),
                    const CustomVerticalSpace(height: 10),
                    CustomTextWidget(
                      values![index].officeName??"",
                      fontColor: AppColor.black,
                      fontSize: 12,
                      fontWeight: AppFontWeight.bold,
                    ),
                    const CustomVerticalSpace(height: 20),

                    CustomTextWidget(
                      "complianace_eng_office_mobile".tr(),
                      fontColor: AppColor.primary700Light,
                      fontSize: 14,
                      fontWeight: AppFontWeight.bold,
                    ),
                    const CustomVerticalSpace(height: 10),
                    CustomTextWidget(
                      values![index].officeMobile??"",
                      fontColor: AppColor.black,
                      fontSize: 12,
                      fontWeight: AppFontWeight.bold,
                    ),

                    const CustomVerticalSpace(height: 20),
                    CustomTextWidget(
                      "order_city".tr(),
                      fontColor: AppColor.primary700Light,
                      fontSize: 14,
                      fontWeight: AppFontWeight.bold,
                    ),
                    const CustomVerticalSpace(height: 10),
                    CustomTextWidget(
                      values![index].cityName??"",
                      fontColor: AppColor.black,
                      fontSize: 12,
                      fontWeight: AppFontWeight.bold,
                    ),

                    // const CustomVerticalSpace(height: 8)
                  ],
                ),
              );
            }),
      ],
    );
  }
}

