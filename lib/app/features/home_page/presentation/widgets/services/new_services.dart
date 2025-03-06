// import 'package:balady_plus/app/core/services/local/navigation_services.dart';
// import 'package:flutter/material.dart';
// import 'package:localize_and_translate/localize_and_translate.dart';
//
// import '../../../../../core/base/base_view_model.dart';
// import '../../../../../core/utils/constants/dialog_names.dart';
// import '../../../../../core/utils/utils_exports.dart';
// import '../../../../_shared_feature_/presentation/dialogs/need_login_dialog.dart';
// import '../../../../_shared_feature_/shared_feature_exports.dart';
// import '../../../../new_appointment/presentation/core/services/view_models/new_appointment_view_model.dart';
// import '../../../../new_appointment/presentation/dialogs/new_appointment_dialog.dart';
// import '../../../home_exports.dart' show HomeSection;
//
// class NewServices extends StatelessWidget {
//   const NewServices({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return HomeSection(
//         title: "newServices".tr(),
//         topPadding: 16,
//         child: Padding(
//           padding: const EdgeInsetsDirectional.only(start: 12),
//           child: SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: Row(
//               children: [
//                 SizedBox(
//                   height: 194,
//                   child: Stack(
//                     children: [
//                       Container(
//                         margin: const EdgeInsetsDirectional.only(
//                             top: 12, bottom: 4, end: 6, start: 6),
//                         width: MediaQuery.sizeOf(context).width / 2.25,
//                         padding: const EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           borderRadius:
//                               const BorderRadius.all(Radius.circular(12)),
//                           color: Colors.transparent,
//                           image: const DecorationImage(
//                               image: AssetImage(ImagePath.union),
//                               fit: BoxFit.fill),
//                           boxShadow: [
//                             BoxShadow(
//                               color:
//                                   AppColor.blackModern900Light.withOpacity(0.1),
//                               blurRadius: 8,
//                               offset: const Offset(0, -4),
//                             ),
//                           ],
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Container(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 8,
//                                 vertical: 4.0,
//                               ),
//                               decoration: BoxDecoration(
//                                 color: AppColor.iceBlue,
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               child: CustomTextWidget(
//                                 "notice".tr(),
//                                 textStyle: AppStyle.tagStyle.copyWith(
//                                   color: AppColor.blackModern700Light,
//                                   fontWeight: FontWeight.w700,
//                                   fontSize: 8,
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(height: 18),
//                             CustomTextWidget(
//                               "notice_service".tr(),
//                               fontColor: AppColor.blackModern800Light,
//                               fontWeight: AppFontWeight.bold,
//                               fontSize: 14,
//                             ),
//                             const SizedBox(height: 6),
//                             CustomTextWidget(
//                               'notice_desc'.tr(),
//                               fontColor: AppColor.blackModern400Light,
//                               fontWeight: AppFontWeight.medium,
//                               maxLines: null,
//                               fontSize: 12,
//                             ),
//                             const SizedBox(height: 16),
//                             CustomElevatedButtonWidget(
//                               btnColor: AppColor.primary900Light,
//                               textStyle: AppStyle.elevatedButtonStyle.copyWith(
//                                 color: AppColor.white,
//                                 fontWeight: FontWeight.w700,
//                                 fontSize: 12,
//                               ),
//                               btnHeight: 40,
//                               btnPadding: const EdgeInsets.all(11),
//                               text: "tickets_show".tr(),
//                               onPressed: () async {
//                                 if (CommonProperties.isLoggedIn) {
//                                   NavigationService.navigatorKey.currentState!
//                                       .pushNamed(
//                                           RouteName.objectableTransactions);
//                                 } else {
//                                   showDialog(
//                                       context: context,
//                                       builder: (ctx) => NeedLoginDialog(
//                                               onSuccessLogin:
//                                                   (bool? isSuccess) async {
//                                             if (isSuccess ?? false) {
//                                               NavigationService
//                                                   .navigatorKey.currentState!
//                                                   .pushNamed(RouteName
//                                                       .objectableTransactions);
//                                             }
//                                           }));
//                                 }
//                               },
//                             ),
//                           ],
//                         ),
//                       ),
//                       PositionedDirectional(
//                         end: 10,
//                         top: 0,
//                         child: Container(
//                           padding: const EdgeInsets.all(11),
//                           decoration: const BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: AppColor.secondary400Light),
//                           child: const CustomSvgIconWidget(
//                             IconPath.warningIcon,
//                             iconSize: 27,
//                             iconColor: AppColor.white,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(
//                   height: 194,
//                   child: Stack(
//                     children: [
//                       Container(
//                         margin: const EdgeInsetsDirectional.only(
//                             top: 12, bottom: 4, end: 6, start: 6),
//                         width: MediaQuery.sizeOf(context).width / 2.25,
//                         padding: const EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           borderRadius:
//                               const BorderRadius.all(Radius.circular(12)),
//                           color: Colors.transparent,
//                           image: const DecorationImage(
//                               image: AssetImage(ImagePath.union),
//                               fit: BoxFit.fill),
//                           boxShadow: [
//                             BoxShadow(
//                               color:
//                                   AppColor.blackModern900Light.withOpacity(0.1),
//                               blurRadius: 8,
//                               offset: const Offset(0, -4),
//                             ),
//                           ],
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Container(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 8,
//                                 vertical: 4.0,
//                               ),
//                               decoration: BoxDecoration(
//                                 color: AppColor.iceBlue,
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               child: CustomTextWidget(
//                                 "تواصل معنا",
//                                 textStyle: AppStyle.tagStyle.copyWith(
//                                   color: AppColor.blackModern700Light,
//                                   fontWeight: FontWeight.w700,
//                                   fontSize: 8,
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(height: 18),
//                             CustomTextWidget(
//                               'schedule_date'.tr(),
//                               fontColor: AppColor.blackModern800Light,
//                               fontWeight: AppFontWeight.bold,
//                               fontSize: 14,
//                             ),
//                             const SizedBox(height: 6),
//                             CustomTextWidget(
//                               'booking_tickets'.tr(),
//                               fontColor: AppColor.blackModern400Light,
//                               fontWeight: AppFontWeight.medium,
//                               maxLines: null,
//                               fontSize: 12,
//                             ),
//                             const SizedBox(height: 16),
//                             CustomElevatedButtonWidget(
//                               btnColor: AppColor.primary900Light,
//                               textStyle: AppStyle.elevatedButtonStyle.copyWith(
//                                 color: AppColor.white,
//                                 fontWeight: FontWeight.w700,
//                                 fontSize: 12,
//                               ),
//                               btnHeight: 40,
//                               btnPadding: const EdgeInsets.all(11),
//                               text: "احجز موعد",
//                               onPressed: () async {
//                                 if (CommonProperties.isLoggedIn) {
//                                   bool isSuccess =
//                                       await locator<NewAppointmentViewModel>()
//                                           .loadInitialData();
//                                   if (isSuccess)
//                                     await BottomSheetDialog.showDraggableSheet(
//                                         context,
//                                         dialogKeyName: DialogName
//                                             .selectAppointmentTypeDialog,
//                                         currentRouteName: "HomePage",
//                                         isFullHeight: false,
//                                         child: BottomSheetWithActions(
//                                           title: "اختر نوع الموعد".tr(),
//                                           body: NewAppointmentDialog(),
//                                         ));
//                                 } else {
//                                   showDialog(
//                                       context: context,
//                                       builder: (ctx) => NeedLoginDialog(
//                                               onSuccessLogin:
//                                                   (bool? isSuccess) async {
//                                             if (isSuccess ?? false) {
//                                               await locator<
//                                                       NewAppointmentViewModel>()
//                                                   .loadInitialData();
//                                               await BottomSheetDialog
//                                                   .showDraggableSheet(context,
//                                                       isFullHeight: false,
//                                                       child:
//                                                           BottomSheetWithActions(
//                                                         title: "اختر نوع الموعد"
//                                                             .tr(),
//                                                         body:
//                                                             NewAppointmentDialog(),
//                                                       ));
//                                             }
//                                           }));
//                                 }
//                               },
//                             ),
//                           ],
//                         ),
//                       ),
//                       PositionedDirectional(
//                         end: 10,
//                         top: 0,
//                         child: Container(
//                           padding: const EdgeInsets.all(11),
//                           decoration: const BoxDecoration(
//                               shape: BoxShape.circle, color: AppColor.brown),
//                           child: const CustomSvgIconWidget(
//                             IconPath.calendarIcon,
//                             iconSize: 27,
//                             iconColor: AppColor.white,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ));
//   }
// }
