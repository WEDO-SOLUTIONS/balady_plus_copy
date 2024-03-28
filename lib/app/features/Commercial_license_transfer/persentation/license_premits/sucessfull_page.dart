
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../../../../core/utils/common_functions.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/app_style.dart';
import '../../../../core/utils/constants/constants.dart';
import '../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../../core/utils/constants/paths/image_paths.dart';
import '../../../../core/utils/constants/route_names.dart';
import '../../../_shared_feature_/balady_features/widgets/shared/circle_icon.dart';
import '../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/draw_icon_based_type_widget.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../bloc/license_tranfer_cubit.dart';
import '../interface/step_interface.dart';

class SucessfullScreen extends StatefulWidget {

  SucessfullScreen({Key? key}) : super(key: key);

  @override
  State<SucessfullScreen> createState() => _SucessfullScreenState();
}

class _SucessfullScreenState extends State<SucessfullScreen> {

  String? requestId;

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {


    requestId= ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
        body: getBody()


    );

  }
  Widget getBody() {




    return
      Padding(
        padding: const EdgeInsets.only(left: 15.0,right: 15),
        child: Stack(
          children:
          [
            Column(
              children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [

                   const DrawIconBasedTypeWidget(
                    icon:IconPath.successfullIcon,
                    iconSize: 120,
                  ),
                  CustomTextWidget(
                    "vd_request_submit".tr(),
                    textStyle: AppStyle.complianceTitleStyle,
                    maxLines: 4,),

                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [


                  Text(
                    "${"request_number".tr()} $requestId ${"follow_request".tr()}",
                    style: AppStyle.personalInfoParameterValueTextStyle
                        .copyWith(fontSize: 12,height: 1.5),
                  ),


                  CustomElevatedButtonWidget(
                    btnColor: Colors.transparent,
                    textStyle: AppStyle.elevatedButtonStyle.copyWith(
                      color: AppColor.blueSkyLight800,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),

                    btnHeight: 56,
                    text: "service_evaluation".tr(),
                    onPressed: (){

                    },),
                  Spacer(),
                  CustomElevatedButtonWidget(
                    btnColor: Colors.transparent,
                    textStyle: AppStyle.elevatedButtonStyle.copyWith(
                      color: AppColor.blueSkyLight800,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                    btnBorderColor: AppColor.blueSkyLight800,
                    btnHeight: 56,
                    text: "show_request".tr(),
                    onPressed: (){
                    Navigator.of(context).pushNamed(
                        RouteName.requestOwnershipTransferDetailsPage,
                        arguments: {
                          "requestNumber": requestId ,
                          "isReadonly":true

                        },
                      );



                    },),
                  const SizedBox(height: 10,),
                  CustomElevatedButtonWidget(
                    btnColor: AppColor.blueSkyLight800,
                    textStyle: AppStyle.elevatedButtonStyle.copyWith(
                      color: AppColor.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                    btnHeight: 56,
                    text: "go_to_license".tr(),
                    onPressed: (){
                      Navigator.popUntil(context,  ModalRoute.withName( RouteName.licenses));
                    },),

                  const SizedBox(height: 50,),
                ],
              ),
            ),],),
            Positioned(
              left:5,
              top: 70,
              child: Padding(
                padding: const EdgeInsetsDirectional.only(end: 10),
                child: InkWell(
                  onTap: (){

                    Navigator.popUntil(context,  ModalRoute.withName( RouteName.licenses));

                  },
                  child: CircleIcon(
                    icon: Icons.close,
                    iconColor: AppColor.primary600Light,
                    backgroundColor: AppColor.geyser.withOpacity(0.4),
                    iconSize: 18,
                  ),
                ),
              ),
            ),
    ]
        ),
      );


  }




}
