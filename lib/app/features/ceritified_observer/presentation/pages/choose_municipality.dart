
import 'package:app_popup_menu/app_popup_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/services/local/navigation_services.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../../core/utils/constants/route_names.dart';
import '../../../_shared_feature_/presentation/widgets/default_appbar_widget.dart';
import '../blocs/choose_muncipality_bloc.dart';




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
          // if (state.cemetryListStatus == BlocStatus.failure ||
          //     state.status == BlocStatus.failure) {
          //   CommonFunctions.showError(state.errorMessage ?? "");
          // }
          //
        },
        builder: (context, state) {
          return  Scaffold(
            appBar: AppBar(
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
                      "ekram_benf_transport".tr(),
                      maxLines: 2,
                      style: const TextStyle(
                        color: AppColor.black,
                        fontSize: 18.0, // Adjust font size for readability
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.start, // Center the title
                    ),
                  ),

                  InkWell(
                    onTap: () => NavigationService.navigatorKey.currentState!
                        .pushNamed(RouteName.EkramRequestTransportationStartService,),
                    child: CircleAvatar(
                      backgroundColor: AppColor.primary50Light,
                      child: SvgPicture.asset(
                        IconPath.add,
                        width: 40,
                        height: 40,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0), // Add consistent spacing
                  // InkWell(
                  //   onTap: () async {
                  //     context
                  //         .read<TransportRequestsBloc>()
                  //         .add(ShowFilterEvent());
                  //   },
                  //   child: CircleAvatar(
                  //     backgroundColor: AppColor.primary50Light,
                  //     child: SvgPicture.asset(
                  //       IconPath.filter,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              // bottom: AppBarSeachBar(
              //   onChanged: (value) {
              //     _debouncer.run(() {
              //       context.read<TransportRequestsBloc>().add(
              //           GetDeceasedTransportRequestsEvent(
              //               isDriver: false, text: value));
              //     });
              //   },
              // ),
            ),
            body: Container(),

          );
        },
      ),
    );




  }
}
