import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../etmam_app/core/utils/common_functions.dart';
import '../../../../../../etmam_app/features/_shared_feature_/shared/presentation/widgets/custom_loading_widget.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/enums/app_font_weights.dart';
import '../../../../../core/utils/enums/bloc_status.dart';
import '../../../../../core/utils/enums/enums.dart';
import '../../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/draw_line_widget.dart';
import '../../../data/model/driver/deceased_identical_item.dart';
import '../../../domain/entities/deceased_request_details/deceased_request_details.dart';
import '../../blocs/driver_extra_data_bloc/extra_data_bloc.dart';
import '../ekram_status_widget.dart';
import 'custom_dropdown_dialog.dart';
import 'package:balady_plus/app/core/dependency_injection/dependency_injection_exports.dart';

import 'deseased_attachment_widget.dart';
class ExtraDataCardWidget extends StatelessWidget {
  final DeceasedIdenticalItem item;
    ExtraDataBloc? bloc;


   ExtraDataCardWidget(
      {Key? key,
        required this.item,
        required this.bloc,

       })
      :super(key: key){
     bloc!.add(GetDeceasedAttachmentEvent(requestId: item.requestId!));
     bloc!.add(GetGhuslEmployeesEvent(requestId: item.requestId!,ghuslEmployeeIdentityNo: item.ghuslEmployeeIdentityNo));

   }


  @override
  Widget build(BuildContext context) {

    return BlocProvider.value(
      value:bloc! ,
        child:
        BlocConsumer<ExtraDataBloc, ExtraDataState>(
          listener: (context, state) {
            if (bloc!.state.status == BlocStatus.failure) {
              //bloc.add(ClearErrorMsgEvent());
              // CommonFunctions.showError(bloc.state.errorMessage ?? "");
            }
          },
          builder: (context, state) {

            return Container(
              width: MediaQuery.of(context).size.width - 60,
              decoration: new BoxDecoration(
                  color: AppColor.white, borderRadius: BorderRadius.circular(16)),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(height: 15,),
                  EkramHeaderAndDescWidget_new(
                    title: ('deceasedName').tr(),
                    details: item.deceasedName ?? "",
                  ),

                 // item.ghuslable ==true ?
                 CustomDropDownDialog(
                    items: bloc!.getGhuslEmployeeByRequestId(item.requestId!) ?? [],
                    selectedValue: state.lstSelectedEmploye?[item.requestId]?.fullName,
                    onChangeType: (var selectedItem) {

                      bloc!.add(SetSelectEmployeeEvent(requestId:item.requestId!, employee: selectedItem ));
                    },
                    onEmptyList: () async {
                      // return context
                      //     .read<AddTripBloc>()
                      //     .getLanuduriesLookUp();
                    },
                    label: "GhuslName".tr()+ (item.ghuslEmployeeRequired==true?" *":""),
                    hint: "GhuslName".tr(),
                  ),
                     //:Container(),


                  ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount:
                    bloc!.getAttachmentByRequestId(item.requestId!)?.length ??
                        0,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (ctx, index) {
                      return DeceasedAttachmentCardWidget(
                        item: bloc!.getAttachmentByRequestId(item.requestId!)![index],bloc: bloc!,requestId: item.requestId!,

                      );
                    },
                  ),

                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20,left: 30,right: 30),
                    child: ElevatedButtonWidget.primaryCustom(
                      btnColor:  AppColor.primary800Light,
                      height: 40,
                      onPressed: () {
                        bloc?.add(EditAdditionalDataEvent(requestId: item.requestId!));

                        // if (widget.model?.startupInfo?.date != null &&
                        //     widget.model?.startupInfo?.time != null
                        //     && widget.model?.arrivalInfo?.date != null &&
                        //     widget.model?.arrivalInfo?.time != null) {
                        //
                        //
                        //   // context.read<AddTripBloc>().add(
                        //   //     EditTripPathData(item: widget.model, hidenScreen: false));
                        // }
                        // else {
                        //   CommonFunctions.showError("please_enter_date_and_time".tr());
                        // }


                      },
                      text: ('saveButton').tr(),
                    ),
                  ),


                  if (state.status == BlocStatus.loading)
                    const CustomLoadingWidget(),

                ],
              ),
            );

          },
        )



    );





  }
}
