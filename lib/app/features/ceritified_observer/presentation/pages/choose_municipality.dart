
import 'package:app_popup_menu/app_popup_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/services/local/navigation_services.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/app_style.dart';
import '../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../../core/utils/constants/route_names.dart';
import '../../../../core/utils/enums/app_font_weights.dart';
import '../../../../core/utils/enums/bloc_status.dart';
import '../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/shimmer_effect_widget.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../profile_features/dashboard/dashboard_exports.dart';
import '../blocs/choose_muncipality_bloc.dart';
import '../widget/choose_muncipality_widget.dart';
import '../widget/wait_for_approval_widget.dart';

class ChooseMunicipality extends StatefulWidget {
  const ChooseMunicipality({Key? key}) : super(key: key);

  @override
  State<ChooseMunicipality> createState() => _ChooseMunicipalityState();
}

class _ChooseMunicipalityState extends State<ChooseMunicipality> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChooseMuncipalityBloc(),
      child: BlocConsumer<ChooseMuncipalityBloc, ChooseMuncipalityState>(
        listener: (context, state) {
        },
        builder: (context, state) {

         // if (state.status == BlocRequestStatus.submissionGetSuccess) {
            return Scaffold(
              appBar:getAppBar(),
              body:  Padding(
              padding: EdgeInsets.only(left: 5.0, right: 5, bottom: 20),
              child: Column(
               mainAxisAlignment: MainAxisAlignment.start,
               children: [

                 ChooseMuncipalityWidget(),



              // state.observerStatusEntity?.qualification ==
              //     "Waiting for approval"
              //     ? const WaitForApprovalWidget()
              //     : Container(),


                  state.status == BlocRequestStatus.submissionGetLoading? const Center(child: CustomCircularLoadingWidget()):Container()

            ],
          ),
        ),
            );
         // }


          return Scaffold(
            appBar:getAppBar(),
            body: const Padding(
              padding: EdgeInsets.only(left: 5.0, right: 5, bottom: 20),
              child: Center(
                child: NoDataWidget(),
              ),
            ),

          );
        },
      ),
    );




  }


  PreferredSizeWidget getAppBar()
  {
    return AppBar(
      titleSpacing: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      iconTheme: const IconThemeData(color: Colors.black),
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios,
                color: AppColor.black),
            onPressed: () {
              Navigator.of(context).pop(); // Navigate back
            },
          ),
          Expanded(
            child: Text(
              "certified_observer".tr(),
              maxLines: 2,
              style: const TextStyle(
                color: AppColor.black,
                fontSize: 18.0, // Adjust font size for readability
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.start, // Center the title
            ),
          ),
          // Add consistent spacing

        ],
      ),

    );
  }
}
