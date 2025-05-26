import 'package:balady_plus/app/features/ekram/ekram_exports.dart';
import 'package:balady_plus/app/features/ekram/presentation/blocs/driver_extra_data_bloc/extra_data_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../core/utils/common_functions.dart';
import '../../../../../../core/utils/constants/app_colors.dart';
import '../../../../../../core/utils/enums/app_font_weights.dart';
import '../../../../../_shared_feature_/presentation/widgets/custom_enhanced_expansion_panel_widget.dart';
import '../../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../../data/model/driver/trip_details_model.dart';
import '../../../blocs/driver_add_trip/add_trip_bloc.dart';

class DriversInfoWidget extends StatelessWidget {
  AddTripBloc? bloc;
   DriversInfoWidget({Key? key,this.bloc}) : super(key: key);

  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: bloc!,
          child: BlocConsumer<AddTripBloc, AddTripState>(
              listener: (context, state) {

    },
            builder: (BuildContext context, state) {

                return  Container(
                  width: MediaQuery.of(context).size.width - 30,
                  decoration: new BoxDecoration(
                      color: AppColor.white, borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomVerticalSpace(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: CustomTextWidget(
                          "tripPaths".tr(),
                          fontSize: 20.0,
                          fontWeight: AppFontWeight.bold,
                          fontColor: AppColor.blackModern700Light,
                          maxLines: 1,
                          textOverflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                        ),
                      ),

                      ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount:
                        state.data?.length ?? 0,
                        shrinkWrap: true,
                        reverse: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (ctx, index) {


                            return getTripPathWidget(context,state.data![index]);


                        },
                      ),





                    ],
                  ),
                );

              }


          )



    );

  }

  Widget getTripPathWidget(BuildContext context, TripDetailsModel model)
  {
    return Container(
      width: MediaQuery.of(context).size.width ,
      decoration: new BoxDecoration(
          color: AppColor.greenOptacty.withOpacity(0.5), borderRadius: BorderRadius.circular(8)),
      // padding: EdgeInsets.all(24),
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomVerticalSpace(height: 15),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomTextWidget(
                "destinationName".tr(),
                fontSize: 12.0,
                fontWeight: AppFontWeight.bold,
                fontColor:AppColor.blackModern700Light ,
                maxLines: 1,
                textOverflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
              ),

              Container(
                padding: EdgeInsets.all(5),
              decoration: new BoxDecoration(
              color: AppColor.athkarAppbarGreen.withOpacity(0.12), borderRadius: BorderRadius.circular(5)),
              child: CustomTextWidget(
                  model.startupInfo?.typeName??"",
                  fontSize: 11.0,
                  fontWeight: AppFontWeight.bold,
                  fontColor:AppColor.primary800Light2 ,
                  maxLines: 1,
                  textOverflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
          const CustomVerticalSpace(height: 10),


          InkWell(
            onTap: () {
              if (model.startupInfo?.location?.x != null && model.startupInfo?.location?.y != null ) {
                CommonFunctions.openMap(
                    double.parse(model.startupInfo!.location!.y!),
                    double.parse(model.startupInfo!.location!.x!));
              }
              else
              {
                CommonFunctions.showError("noData".tr());
              }

            },
            child: CustomTextWidget(
              ("destinationTime").tr(),
              fontSize: 11,
              fontWeight: AppFontWeight.bold,
              fontColor: AppColor.primary800Light2,
              textAlign: TextAlign.start,
            ),
          ),


          const CustomVerticalSpace(height: 10),

          CustomTextWidget(
            "${model.startupInfo?.date != null ? CommonFunctions.getFormattedDateEkram(
                model.startupInfo?.date):""}  ${model.startupInfo?.time != null? CommonFunctions.getFormattedTimeEkram(model.startupInfo?.time!):""} ",
            fontSize: 11.0,
            fontWeight: AppFontWeight.medium,
            fontColor: AppColor.litgrey,
            maxLines: 1,
            textOverflow: TextOverflow.ellipsis,
            textAlign: TextAlign.start,
          ),

          const CustomVerticalSpace(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomTextWidget(
                "arrivalName".tr(),
                fontSize: 11.0,
                fontWeight: AppFontWeight.bold,
                fontColor:AppColor.blackModern700Light ,
                maxLines: 1,
                textOverflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
              ),

              Container(
                padding: EdgeInsets.all(5),
                decoration: new BoxDecoration(
                    color: AppColor.athkarAppbarGreen.withOpacity(0.12), borderRadius: BorderRadius.circular(5)),
                child: CustomTextWidget(
                  model.arrivalInfo?.typeName??"",
                  fontSize: 11.0,
                  fontWeight: AppFontWeight.bold,
                  fontColor:AppColor.primary800Light2 ,
                  maxLines: 1,
                  textOverflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
          const CustomVerticalSpace(height: 10),
          InkWell(
            onTap: () {
              if (model.arrivalInfo?.location?.x != null && model.arrivalInfo?.location?.y != null ) {
                CommonFunctions.openMap(
                    double.parse(model.arrivalInfo!.location!.y!),
                    double.parse(model.arrivalInfo!.location!.x!));
              }
              else
              {
                CommonFunctions.showError("noData".tr());
              }

            },
            child: CustomTextWidget(
              ("destinationTime").tr(),
              fontSize: 11,
              fontWeight: AppFontWeight.bold,
              fontColor: AppColor.primary800Light2,
              textAlign: TextAlign.start,
            ),
          ),



          const CustomVerticalSpace(height: 10),
          CustomTextWidget(
            "${model.arrivalInfo?.date != null ? CommonFunctions.getFormattedDateEkram(
                model.arrivalInfo?.date):""}  ${model.arrivalInfo?.time != null? CommonFunctions.getFormattedTimeEkram(model.arrivalInfo?.time!):""} ",

            fontSize: 11.0,
            fontWeight: AppFontWeight.bold,
            fontColor: AppColor.litgrey,
            maxLines: 1,
            textOverflow: TextOverflow.ellipsis,
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }
}
