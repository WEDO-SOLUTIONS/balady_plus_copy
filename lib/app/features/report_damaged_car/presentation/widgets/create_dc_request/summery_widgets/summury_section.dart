import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/report_damaged_car/presentation/widgets/create_dc_request/summery_widgets/car_summury_widget.dart';
import 'package:balady_plus/app/features/report_damaged_car/presentation/widgets/create_dc_request/summery_widgets/plate_summury_widget.dart';
import 'package:balady_plus/app/features/report_damaged_car/presentation/widgets/create_dc_request/summery_widgets/pledges_summury_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../core/utils/enums/enums.dart';
import '../../../../../_shared_feature_/presentation/widgets/custom_cupertino_drop_down_widget.dart';
import '../../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../../vd/presentation/widgets/vd_header_desc_widget.dart';
import '../../../blocs/create_dc_request/create_dc_details_bloc/create_dc_bloc.dart';
import '../details_widgets/previous_next_buttons.dart';
import 'description_summury_widget.dart';
import 'location_summury_widget.dart';

class SummurySection extends StatefulWidget {
  const SummurySection({Key? key}) : super(key: key);

  @override
  State<SummurySection> createState() => _SummurySectionState();
}

class _SummurySectionState extends State<SummurySection> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToEnd());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateDCBloc, CreateDCState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Container(
                  margin: EdgeInsets.only(top: 24, left: 16, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      VdHeaderDesc(
                        header: ("vd_confirm_location_photo").tr(),
                      ),
                      LocationSummuryWidget(),
                      CustomVerticalSpace(height: 16),
                      CarSummuryWidget(),
                      CustomVerticalSpace(height: 16),
                      PlateSummuryWidget(),
                      CustomVerticalSpace(height: 16),
                      DescriptionSummuryWidget(),
                      CustomVerticalSpace(height: 16),
                      PledgesSummuryWidget()
                    ],
                  ),
                ),
              ),
            ),
            PreviousNextButtons()
          ],
        );
      },
    );
  }

  _scrollToEnd() async {
    _scrollController.animateTo(_scrollController!.position.maxScrollExtent,
        duration: const Duration(milliseconds: 400), curve: Curves.ease);
  }
}

class LocationSection extends StatelessWidget {
  bool? hideAutomaticLocationdetected;

  LocationSection({this.hideAutomaticLocationdetected});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateDCBloc, CreateDCState>(
      builder: (context, state) {
        return CustomHeaderAndDescOnTapWidget(
          label: ("vd_location").tr(),
          hintText: ("lbl_locate_report_from_here").tr(),
          textValue: state.gisResponse?.getFullAddress(),
          materialIconDirection: CommonFunctions.isAppAR
              ? MATERIAL_ICON_DIRECTION.left
              : MATERIAL_ICON_DIRECTION.right,
          onTap: () {
            context.read<CreateDCBloc>().add(ChangeAddressEvent());
          },
          icon: const Icon(Icons.location_on, color: AppColor.greenLight),
        );
      },
    );
  }
}
