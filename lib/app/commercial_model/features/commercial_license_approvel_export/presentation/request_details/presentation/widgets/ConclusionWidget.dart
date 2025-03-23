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

import '../../../../../../../core/services/local/navigation_services.dart';
import '../../../../../../../core/utils/constants/app_style.dart';
import '../../../../../../../core/utils/constants/remote_config.dart';
import '../../../../../../../core/utils/enums/bloc_status.dart';
import '../../../../../../../features/_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../../../../../../features/_shared_feature_/presentation/widgets/reload_widget.dart';
import '../../../../domain/entities/conclusion_section.dart';
import '../../../intial_approval/step3/widgets/print_preview.dart';
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

                ExpansionSectionItem(term: context.read<CommercialLicenseDetailsBloc>().getConclusionSection(lstPreDefinedConditionsByType:state.issueCommercialConculsionEntity?.lstPreDefinedConditionsByType),sectionName: "PreDefinedConditionsByTypeTitle".tr(),),

                ExpansionSectionItem(term:ConclusionSection(sectionContent:ConSectionContent(label: "municipalAdvisorBoardsRequirements".tr(),value: [  "${RemoteConfig.webSiteUrl}/${translator.activeLanguageCode}/Services/DownloadUserGuide/218"]) ,sectionName: "municipalAdvisorBoardsRequirements".tr()),isUnderLine: true,sectionName: "",),
                ExpansionSectionItem(term:ConclusionSection(sectionContent:ConSectionContent(label: "Viewmunicipalrequirements".tr(),value: [  "${RemoteConfig.baladyBaseUrl}/LicenseStandard/Default?sid=7010"]) ,sectionName: "Viewmunicipalrequirements".tr()),isUnderLine: true,sectionName: "",),


                ExpansionSectionItem(term: context.read<CommercialLicenseDetailsBloc>().getConclusionSection(allowedPermits:state.issueCommercialConculsionEntity?.allowedPermits),note: "premits_limit".tr(),sectionName: "permits".tr(),),
                ExpansionSectionItem(term: context.read<CommercialLicenseDetailsBloc>().getConclusionSection(civilDefenseDocuments:state.issueCommercialConculsionEntity?.civilDefenseAllowedDocuments),sectionName:  "municipalAdvisorCivilDefenseTitle".tr(),),
                ExpansionSectionItem(term: context.read<CommercialLicenseDetailsBloc>().getConclusionSection(lstSupervisingAuthorities:state.issueCommercialConculsionEntity?.supervisingAuthoritiesForActivities),sectionName: "SupervisingAuthorities".tr(),),

                ExpansionSectionItem(term: context.read<CommercialLicenseDetailsBloc>().getConclusionSection(cleaningOptions:state.issueCommercialConculsionEntity?.cleaningOptions),sectionName: "municipalAdvisorCleaningMechanismsTitle".tr()),

                OfficeExpansionSectionItem(term: context.read<CommercialLicenseDetailsBloc>().getConclusionSection(engOffices:state.issueCommercialConculsionEntity?.engOffices),sectionName: "municipalAdvisorEngineeringOfficesTitle".tr(),),
                OfficeExpansionSectionItem(term: context.read<CommercialLicenseDetailsBloc>().getConclusionSection(commercialOffices:state.issueCommercialConculsionEntity?.commercialOffices),sectionName: "commercialOffice".tr(),),
                OfficeExpansionSectionItem(term: context.read<CommercialLicenseDetailsBloc>().getConclusionSection(lstboardContractRequirementMessage:state.issueCommercialConculsionEntity?.lstboardContractRequirementMessage),sectionName: "boardContractRequirementMessage".tr(),),

                ExpansionSectionItem(term: context.read<CommercialLicenseDetailsBloc>().getConclusionSection(lstFastFlowConditions:state.issueCommercialConculsionEntity?.lstFastFlowConditions),sectionName: "fastFlowConditions".tr(),showPrint: true,),


                state.issueCommercialConculsionEntity?.calculateStandardFees != null?

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
  final String sectionName;
  final bool? isUnderLine;
  final bool? showPrint;

  const ExpansionSectionItem({super.key, required this.term,required this.sectionName,this.note,this.isUnderLine,this.showPrint});

  @override
  Widget build(BuildContext context) {
    return term != null?
    Column(
      children: [
        ConditionItem(name:  term!.sectionName, values:  term?.sectionContent?.value ?? [],note: note,isUnderLine: isUnderLine,showPrint: showPrint,),
        const SizedBox(height: 15,),
      ],
    ):

    Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
          color: Color(0x80E6EFEF),
          borderRadius: BorderRadius.all(Radius.circular(8))),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            CustomTextWidget(
              sectionName,
              fontColor: AppColor.primary700Light,
              fontSize: 12,
              fontWeight: AppFontWeight.bold,
            ),

            const CustomVerticalSpace(height: 4),
          Text("noData".tr())

        ],
      ),
    );





  }
}

class ConditionItem extends StatelessWidget {
  final String? name;
  final String? note;
  final List<String>? values;
  final bool? isUnderLine;
  final bool? showPrint;
  const ConditionItem({super.key, this.name, this.values,this.note,this.isUnderLine,this.showPrint});

  @override
  Widget build(BuildContext context) {
    return
      Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
          color: Color(0x80E6EFEF),
          borderRadius: BorderRadius.all(Radius.circular(8))),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          note != null?NotesWidget(notes: [note!], marginBottom: 10,showText: true,padding: 10,separatorHeight: 2,):Container(),


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
  String sectionName;


   OfficeExpansionSectionItem({super.key, required this.term, required this.sectionName});


  @override
  Widget build(BuildContext context) {
    return term != null?Column(
      children: [
        OfficeItem(values:  term?.sectionContent?.offices ?? [],name: term?.sectionName,),

        const SizedBox(height: 15,),
      ],
    ):
    Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
          color: Color(0x80E6EFEF),
          borderRadius: BorderRadius.all(Radius.circular(8))),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextWidget(
            sectionName,
            fontColor: AppColor.primary700Light,
            fontSize: 12,
            fontWeight: AppFontWeight.bold,
          ),

          const CustomVerticalSpace(height: 4),
          Text("noData".tr())

        ],
      ),
    );
  }


}

class OfficeItem extends StatelessWidget {
  final String? name;
  final List<OfficeSection>? values;
  const OfficeItem({super.key, this.values,required this.name});

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

          if (name != null && name!.isNotEmpty)
            CustomTextWidget(
              name!,
              fontColor: AppColor.primary700Light,
              fontSize: 12,
              fontWeight: AppFontWeight.bold,
            ),
          if (name != null && name!.isNotEmpty)
            const CustomVerticalSpace(height: 20),


          ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: values?.length ?? 0,
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                      color: AppColor.white,
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
      ),
    );
  }
}

