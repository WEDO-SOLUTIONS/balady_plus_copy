// import 'package:flutter/material.dart';
//
// class AudioPanel extends StatefulWidget {
//   const AudioPanel({super.key});
//
//   @override
//   State<AudioPanel> createState() => _AudioPanelState();
// }
//
// class _AudioPanelState extends State<AudioPanel> {
//   @override
//   Widget build(BuildContext context) =>
//       DraggableScrollableSheet(
//         controller: _sheetController,
//         initialChildSize: _minChildSize,
//         minChildSize: _minChildSize,
//         maxChildSize: _maxChildSize,
//         builder: (context, scrollController) => Container(
//           decoration: const BoxDecoration(
//             color: Colors.black,
//           ),
//           child: SingleChildScrollView(
//             controller: scrollController,
//             physics: const ClampingScrollPhysics(),
//             child: Column(
//               children: [
//                 Container(
//                   width: 40,
//                   height: 3,
//                   margin: const EdgeInsets.symmetric(vertical: 16),
//                   decoration: BoxDecoration(
//                     color: Colors.grey,
//                     borderRadius: BorderRadius.circular(36),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 const PlayingAudioTile(),
//                 const SizedBox(height: 32),
//                 const MediaCatalogList(),
//               ],
//             ),
//           ),
//         ),
//       );
// }
