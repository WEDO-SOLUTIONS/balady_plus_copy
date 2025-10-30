import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/need_login_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/constants/dialog_names.dart';
import '../../../../core/utils/constants/ux_cam_events.dart';
import '../../data/models/zmzm_item_model.dart';
import '../bloc/zmzm_bloc.dart';
import '../widgets/zmzm_app_bar.dart';
import '../widgets/zmzmz_card_widget.dart';

class ZmZmPointsPage extends StatefulWidget {
  const ZmZmPointsPage({super.key});

  @override
  State<ZmZmPointsPage> createState() => _ZmZmPointsPageState();
}

class _ZmZmPointsPageState extends State<ZmZmPointsPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CommonFunctions.sendUXCamEvent(UXCamEvents.startServiceZamzamOutlets);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ZmZmBloc(),
      child: BlocBuilder<ZmZmBloc, ZmZmState>(
        builder: (context, state) {
          List<ZMZMItemModel> items = state.selectedItems;
          return Scaffold(
            appBar: ZmZmAppBar(
              currentCity: state.selectedCity,
              onChangeCityPressed: () {
                BottomSheetDialog.showDraggableSheet(
                  isFullHeight: false,
                  context,
                  dialogKeyName: DialogName.ZmZmPointsCityDialog,
                  currentRouteName: RouteName.ZmZmPointsPage,
                  child: BottomSheetList(
                    title: "city_select".tr(),
                    items: state.cities ?? [],
                    selectedValue: state.selectedCity,
                    onTap: (item) {
                      // CommonFunctions.sendUrbiMapLogs();
                      context.read<ZmZmBloc>().add(ChangeCityEvent(city: item));
                      Navigator.pop(context);
                    },
                  ),
                );
              },
            ),
            body: Container(
                padding: EdgeInsets.all(16),
                child: state.selectedCity == null
                    ? EmptyListWidget(
                        title: "no_data_shown".tr(),
                      )
                    : ListView.builder(
                        itemCount: items.length,
                        shrinkWrap: true,
                        itemBuilder: (ctx, index) {
                          return ZMZMCardWidget(item: items[index]);
                        })),
          );
        },
      ),
    );
  }
}
