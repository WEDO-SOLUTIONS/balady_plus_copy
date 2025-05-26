import 'package:flutter/cupertino.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/services/local/navigation_services.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/enums/app_font_weights.dart';
import '../../../../core/utils/etmam_route_exports.dart';
import '../../../_shared_feature_/presentation/dialogs/dialog_header.dart';
import '../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/custom_popups_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/radio_buttons/custom_radio_button_widget copy.dart';
import '../../data/model/driver/transport_request_item_model.dart';
import '../../data/model/driver/trip_details_model.dart';
import '../../data/model/driver/trip_stations.dart';
import '../blocs/driver_add_trip/add_trip_bloc.dart';
import '../pages/driver/add_custom_trip_path.dart';
import '../pages/driver/add_suggested_path.dart';

class AddNewTripPathDailog extends StatefulWidget {
  final AddTripBloc bloc;
  String title;


  AddNewTripPathDailog(
      {Key? key,
        required this.title,
        required this.bloc,
      })
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AddNewTripPathDailog();
  }
}

class _AddNewTripPathDailog extends State<AddNewTripPathDailog> {

  List<TripDetailsModel> items = [];
  TripDetailsModel? currentSelected;

  //List<SpecializedClassificationItem> items = [];
  final ScrollController _scrollController = ScrollController();
  bool isButtonDisabled = true;
  TripDetailsModel? lastTripPath=null;

  @override
  void initState() {
    super.initState();

    items.clear();
    for (var index = 0; index <widget.bloc.state.data!.length; index++) {

      if(widget.bloc.state.data![index].isSuggestPath==true)
        {
          items.add(widget.bloc.state.data![index]);
        }
      else {
        lastTripPath = widget.bloc.state.data![index];
      }
    }
    items.add(TripDetailsModel(id: -1));


  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 20, left: 20, top: 26, bottom: 10),
      child: Column(
        children: [
          // header
          DialogHeader(
            title: widget.title,
          ),


          const CustomVerticalSpace(height: 20),
          // incident type list
          Expanded(
            child: ListView.builder(
              //   itemCount: items != null ? items.length : 0,
                itemCount: items.length,
                shrinkWrap: true,
                controller: _scrollController,
                itemBuilder: (ctx, index) {


                    return CustomRadioButtonEnd<TripDetailsModel>(

                      title:index == items.length-1? "add_Custom_Path".tr():"${"from".tr()} ${items[index].startupInfo
                          ?.typeName}${ " ${"to".tr()}"} ${items[index]
                          .arrivalInfo?.typeName}",
                      value: items[index],
                      isDisabled: false,

                      currentSelected: currentSelected ?? items[0],
                      onChange: onItemChanged,
                    );

                }),
          ),
          const CustomVerticalSpace(height: 5),
          // button
          EnhancedCustomElevatedButtonWidget(
            btnColor:
            isButtonDisabled ? AppColor.black200 : AppColor.primary900Light,
            btnTextColor: isButtonDisabled ? AppColor.black400 : AppColor.white,
            btnPressed: isButtonDisabled
                ? null
                : () async {
              Navigator.of(context).pop();

              if (currentSelected != null) {

                if(currentSelected?.arrivalInfo==null)
                  {


                    if(lastTripPath != null) {
                      TripStations startUp = TripStations(

                          typeName: lastTripPath!.arrivalInfo?.typeName,
                          typeId: lastTripPath!.arrivalInfo?.typeId,
                          cityName: lastTripPath!.arrivalInfo?.cityName,
                          name: lastTripPath!.arrivalInfo?.name,
                          date: null,
                          time: null


                      );

                      widget.bloc.add(setCustomPathDataEvent(
                          item: startUp, isStartupInfo: true));
                    }
                    await CustomPopUpsWidgets.showBottomSheet(
                      NavigationService.navigatorKey.currentContext!,
                      child: AddCustomTripPath(bloc: widget.bloc,),
                    );
                  }
                else {
                  await CustomPopUpsWidgets.showBottomSheet(
                    NavigationService.navigatorKey.currentContext!,
                    child: AddSuggestedPath(bloc: widget.bloc, trip: currentSelected!,),
                  );
                }


               // widget.onSelect(currentSelected!);
              }
            },
            btnText: ("bookNewAppointmentSelectWord").tr(),
            btnTextSize: 16,
            btnTextWeight: AppFontWeight.regular,
            btnHeight: 56,
            btnRadius: 8,
          )
        ],
      ),
    );
  }

  void onItemChanged(TripDetailsModel item) {
    FocusScope.of(context).unfocus();
    isButtonDisabled = false;
    setState(() {
      currentSelected = item;
    });
  }


}
