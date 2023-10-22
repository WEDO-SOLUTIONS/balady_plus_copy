// import 'dart:math';

// import 'package:flutter/material.dart' hide Gradient;
// import 'package:shimmer/shimmer.dart';
// import 'package:uikit/stories/list/components/stories_title.dart';

// class StoryThumbnailsShimmer extends StatelessWidget {
//   final int length;

//   const StoryThumbnailsShimmer({super.key, required this.length});

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         return Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const StoriesTitle(title: 'جديدنا'),
//             SizedBox(
//               width: constraints.maxWidth,
//               height: min(constraints.maxHeight, 120),
//               child: ListView.separated(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: length,
//                 itemBuilder: (context, i) => Padding(
//                   padding: EdgeInsets.only(right: i == 0 ? 16 : 0, left: i == length - 1 ? 16 : 0),
//                   child: Shimmer(
//                     gradient: LinearGradient(colors: [Colors.grey, Colors.grey[200]!]),
//                     child: const AspectRatio(
//                       aspectRatio: 98 / 112,
//                     ),
//                   ),
//                 ),
//                 separatorBuilder: (context, index) => const SizedBox(width: 8),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
