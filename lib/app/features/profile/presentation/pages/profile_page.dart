// import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
// import 'package:balady_plus/app/core/utils/constants/paths/image_paths.dart';
// import 'package:balady_plus/app/features/_shared_feature_/presentation/buttons/circular_container_icon_button.dart';
// import 'package:balady_plus/app/features/entry_point/presentation/cubit/auth_cubit.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_uxcam/flutter_uxcam.dart';
// import 'package:localize_and_translate/localize_and_translate.dart'
//     show Translation;
//
// import '../../../../core/dependency_injection/injection_container.dart';
// import '../../../../core/utils/app_analytics_events.dart';
// import '../../../../core/utils/common_functions.dart';
// import '../../../../core/utils/utils_exports.dart'
//     show CommonProperties, ImagePath;
// import '../../../_shared_feature_/shared_feature_exports.dart'
//     show DefaultAppBarWidget, ElevatedButtonWidget, TabPageContainer;
// import '../../../profile_features/delegators/delegators_exports.dart'
//     show DelegatorsCubit, DelegatorsState;
// import '../../profile_exports.dart'
//     show ProfileCard, ProfileListCard, ProfileSections, SignInCard;
//
// class ProfilePage extends StatefulWidget {
//   const ProfilePage({super.key});
//
//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }
//
// class _ProfilePageState extends State<ProfilePage> {
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//
//     CommonFunctions.sendEventToAnalytics(AppEvents.more);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<EntryPointCubit, EntryPointState>(
//       builder: (context, state) {
//         bool isLoggedin = CommonProperties.isLoggedIn;
//         final list = isLoggedin
//             ? ProfileSections.profileSections
//             : ProfileSections.profileSectionsForGuest;
//         return Scaffold(
//           appBar: DefaultAppBarWidget(
//             title: "profile".tr(),
//             flexibleSpace: const Image(
//               image: AssetImage(ImagePath.appBarGradientBackground),
//               fit: BoxFit.cover,
//             ),
//             actions: [
//               /* CircularContainerForIcons(
//                 onTap: () {},
//                 iconPath: IconPath.notification,
//                 width: 48,
//                 height: 48,
//                 color: Colors.white,
//               )*/
//             ],
//           ),
//           body: TabPageContainer(
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   BlocBuilder<DelegatorsCubit, DelegatorsState>(
//                     builder: (context, state) {
//                       return ProfileCard(
//                         isListItem: false,
//                         agent: isLoggedin ? state.selectedAgent : null,
//                         delegator: isLoggedin ? state.selectedDelegate : null,
//                         userInfo: isLoggedin ? CommonProperties.userInfo : null,
//                       );
//                     },
//                   ),
//                   if (!isLoggedin) const SignInCard(),
//                   ...List.generate(
//                     list.length,
//                     (index) => GestureDetector(
//                       child: ProfileListCard(
//                         section: list[index],
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(30),
//                     child: Image.asset(
//                       ImagePath.logo2030,
//                       fit: BoxFit.fill,
//                       width: MediaQuery.sizeOf(context).width,
//                       height: 32,
//                     ),
//                   ),
//                   if (isLoggedin)
//                     Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: ElevatedButtonWidget.logout(onPressed: () {
//                         sl<EntryPointCubit>().clearAuth();
//                       }),
//                     )
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
