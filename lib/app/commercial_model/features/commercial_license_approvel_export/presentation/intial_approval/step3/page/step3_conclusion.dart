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
import '../../commercial_license/widgets/intial_approval_previous_next_button.dart';
import '../bloc/step3_conclusion_cubit.dart';
import '../widgets/calculator.dart';
import '../widgets/print_preview.dart';


class Step3ConclusionPage extends StatefulWidget {


  const Step3ConclusionPage({super.key});

  @override
  State<Step3ConclusionPage> createState() => _Step3ConclusionPageState();
}

class _Step3ConclusionPageState extends State<Step3ConclusionPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<Step3ConclusionCubit>().getConclusion();
  }
  @override
  Widget build(BuildContext context) {

    return BlocConsumer<Step3ConclusionCubit, Step3ConclusionState>(
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

          SizedBox(height: 10,),
          NotesWidget(notes: [state.workFlowName!], marginBottom: 0,showText: true,padding: 10,separatorHeight: 1,BgColor: AppColor.lightOrange100,),
          SizedBox(height: 16,),
          CustomTextWidget(
            "municipalAdvisorRequirementsTitle".tr(),
            fontColor: AppColor.primary700Light,
            fontSize: 18,
            fontWeight: AppFontWeight.bold,
          ),
          const SizedBox(height: 16),
          (state.status == BlocStatus.failure)?
          ReloadWidget(
            onTab: () {
              context.read<Step3ConclusionCubit>().getConclusion();
            },):Container(),
          
          
          (state.status == BlocStatus.success)?
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  if(state.workFlowName != null)




                 ExpansionSectionItem(term: context.read<Step3ConclusionCubit>().getConclusionSection(lstPreDefinedConditionsByType:state.issueCommercialConculsionEntity?.lstPreDefinedConditionsByType),sectionName: "PreDefinedConditionsByTypeTitle".tr(),),

                  ExpansionSectionItem(term:ConclusionSection(sectionContent:ConSectionContent(label: "municipalAdvisorBoardsRequirements".tr(),value: [  "${RemoteConfig.webSiteUrl}/${translator.activeLanguageCode}/Services/DownloadUserGuide/218"]) ,sectionName: "municipalAdvisorBoardsRequirements".tr()),isUnderLine: true,sectionName: "",),
                  ExpansionSectionItem(term:ConclusionSection(sectionContent:ConSectionContent(label: "Viewmunicipalrequirements".tr(),value: [  "${RemoteConfig.baladyBaseUrl}/LicenseStandard/Default?sid=7010"]) ,sectionName: "Viewmunicipalrequirements".tr()),isUnderLine: true,sectionName: "",),


                  ExpansionSectionItem(term: context.read<Step3ConclusionCubit>().getConclusionSection(allowedPermits:state.issueCommercialConculsionEntity?.allowedPermits),note: "premits_limit".tr(),sectionName: "permits".tr(),),
                  ExpansionSectionItem(term: context.read<Step3ConclusionCubit>().getConclusionSection(civilDefenseDocuments:state.issueCommercialConculsionEntity?.civilDefenseAllowedDocuments),sectionName:  "municipalAdvisorCivilDefenseTitle".tr(),),
                  ExpansionSectionItem(term: context.read<Step3ConclusionCubit>().getConclusionSection(lstSupervisingAuthorities:state.issueCommercialConculsionEntity?.supervisingAuthoritiesForActivities),sectionName: "SupervisingAuthorities".tr(),),

                  ExpansionSectionItem(term: context.read<Step3ConclusionCubit>().getConclusionSection(cleaningOptions:state.issueCommercialConculsionEntity?.cleaningOptions),sectionName: "municipalAdvisorCleaningMechanismsTitle".tr()),

                  OfficeExpansionSectionItem(term: context.read<Step3ConclusionCubit>().getConclusionSection(engOffices:state.issueCommercialConculsionEntity?.engOffices),sectionName: "municipalAdvisorEngineeringOfficesTitle".tr(),),
                  OfficeExpansionSectionItem(term: context.read<Step3ConclusionCubit>().getConclusionSection(commercialOffices:state.issueCommercialConculsionEntity?.commercialOffices),sectionName: "commercialOffice".tr(),),
                  OfficeExpansionSectionItem(term: context.read<Step3ConclusionCubit>().getConclusionSection(lstboardContractRequirementMessage:state.issueCommercialConculsionEntity?.lstboardContractRequirementMessage),sectionName: "boardContractRequirementMessage".tr(),),
                  ExpansionSectionItem(term: context.read<Step3ConclusionCubit>().getConclusionSection(lstFastFlowConditions:state.issueCommercialConculsionEntity?.lstFastFlowConditions),sectionName: "fastFlowConditions".tr(),showPrint: true,),


                  state.issueCommercialConculsionEntity?.calculateStandardFees != null?  CustomExpansionPanelWidget(
                      title:"fee_calculator_license".tr(),
                      leading: SvgPicture.asset(IconPath.serviceCardDesc),
                      children: [CalcualtorFees(),]
                  ):Container(),
                  const SizedBox(height: 15,),
      
      
      
      
                ],
              ),
            ),
          ):Expanded(child: Container()),
          

      
          (state.status == BlocStatus.loading)
              ? const Center(child: CustomCircularLoadingWidget()):Container(),





          IntialApprovalPreviousNextButtons(
            onPressed: () {
              context.read<Step3ConclusionCubit>()
                  .SubmitInitialApproval();
            }, isBtnDisabled: false,
          ),
      
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
  final String sectionName;
  final bool? showPrint;

  const ExpansionSectionItem({super.key, required this.term,required this.sectionName,this.note,this.isUnderLine,this.showPrint});

  @override
  Widget build(BuildContext context) {
    return term != null?
    Column(
      children: [
        CustomExpansionPanelWidget(
          title: term?.sectionName,
          leading: SvgPicture.asset(IconPath.serviceCardDesc),
          children: [

            ConditionItem(name: term?.sectionContent?.label, values:  term?.sectionContent?.value ?? [],note: note,isUnderLine:isUnderLine,showPrint: showPrint,)]
          ,
        ),
        const SizedBox(height: 15,),
      ],
    ): Column(
      children: [
        CustomExpansionPanelWidget(
            title: sectionName,
            leading: SvgPicture.asset(IconPath.serviceCardDesc),
          children:[ Container(
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
                color: Color(0x80E6EFEF),
                borderRadius: BorderRadius.all(Radius.circular(8))),
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomVerticalSpace(height: 4),
                Text("noData".tr())

              ],
            ),
          ),]

        ),
        const SizedBox(height: 15,),
      ],
    );
  }
}


class ConditionItem extends StatelessWidget {
  final String? name;
  final String? note;
  final bool? isUnderLine;
  final List<String>? values;
  final bool? showPrint;
  const ConditionItem({super.key, this.name, this.values,this.note,this. isUnderLine,this.showPrint});

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomTextWidget(
                  name!,
                  fontColor: AppColor.primary700Light,
                  fontSize: 12,
                  fontWeight: AppFontWeight.bold,
                ),
                if(showPrint==true)
                  Text.rich(
                    TextSpan(
                      text: "issue_commercial_print".tr(),
                      style: AppStyle.lightTextStyle.copyWith(
                          decoration: TextDecoration.underline,
                          fontSize: 15,
                          color: AppColor.blue
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>  PrintPreview(values?.join("\n")??"" )),
                          );
                          //Navigator.of(context).push(PrintPreview)
                          // NavigationService.navigatorKey.currentContext.push();
                        },
                    ),
                  )


              ],
            ),
          if (name != null && name!.isNotEmpty)
            const CustomVerticalSpace(height: 4),

          ((values?.length ?? 0) <= 1)?
            isUnderLine==true?
            Text.rich(
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
                      values?[0],

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
  final String sectionName;

   OfficeExpansionSectionItem({super.key, required this.term, required this.sectionName});

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
    ): Column(
      children: [
        CustomExpansionPanelWidget(
            title: sectionName,
            leading: SvgPicture.asset(IconPath.serviceCardDesc),
            children:[ Container(
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                  color: Color(0x80E6EFEF),
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const CustomVerticalSpace(height: 4),
                  Text("noData".tr())

                ],
              ),
            ),]

        ),
        const SizedBox(height: 15,),
      ],
    );
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

