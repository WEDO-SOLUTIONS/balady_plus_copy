// import 'package:balady_plus/app/features/map_page/presentation/mvvm/layers_gis_view_model.dart';
// import 'package:balady_plus/app/features/map_page/presentation/mvvm/map_view_model.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:provider/provider.dart';
//
// import '../../../../core/dependency_injection/injection_container.dart';
// import '../../../_shared_feature_/shared_feature_exports.dart'
//     show TabPageContainer;
// import '../../home_exports.dart' show HomeBottomSheet, HomeMap;
//
// final GlobalKey<NavigatorState> mapKey = new GlobalKey<NavigatorState>();
//
// class HomePage extends StatefulWidget {
//   const HomePage({super.key, required this.hideControls});
//
//   final bool hideControls;
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> /*with WidgetsBindingObserver*/ {
//   @override
//   void dispose() {
//     super.dispose();
//     //  WidgetsBinding.instance.removeObserver(this);
//   }
//
//   /*@override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.resumed) {
//       setState(() {});
//
//     }
//   }*/
//
//   @override
//   void initState() {
//     super.initState();
//
//     SchedulerBinding.instance.addPostFrameCallback((_) {
//       MapViewModel mapViewModel =
//           Provider.of<MapViewModel>(context, listen: false);
//     });
//
//     // WidgetsBinding.instance.addObserver(this);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     MapViewModel mapViewModel = context.watch<MapViewModel?>()!;
//     return Scaffold(
//       key: mapKey,
//       resizeToAvoidBottomInset: false,
//       body: TabPageContainer(
//         child: Stack(
//           children: [
//             HomeMap(
//               hideControls: widget.hideControls,
//             ),
//             if (!widget.hideControls) const HomeBottomSheet(),
//           ],
//         ),
//       ),
//     );
//   }
// }
