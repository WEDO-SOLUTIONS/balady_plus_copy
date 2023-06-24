import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../_shared_feature_/presentation/widgets/check_boxes/custom_check_box_widget.dart';
import '../../core/models/lookup_list_model.dart';

class BookAppointmentSpecialNeedsWidget extends StatefulWidget {
  final Function onSelected;

  //LookUpList list;

  BookAppointmentSpecialNeedsWidget(
      {Key? key, required this.onSelected /*, required this.list*/
      })
      : super(key: key);

  @override
  State<BookAppointmentSpecialNeedsWidget> createState() =>
      _BookAppointmentSpecialNeedsWidgetState();
}

class _BookAppointmentSpecialNeedsWidgetState
    extends State<BookAppointmentSpecialNeedsWidget>
    with AutomaticKeepAliveClientMixin {
  List<LookUpItem> lookupItem = [];

  @override
  void initState() {
    //lookupItem = widget.list.data?.result ?? [];
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CustomCheckBoxWidget(
      //MM11
      onChanged: (bool? data) => widget.onSelected(data),
      selected: false,
      label: ("bookNewAppointmentCheckBoxSpecialNeedsWord").tr(),
    );
  }
}
