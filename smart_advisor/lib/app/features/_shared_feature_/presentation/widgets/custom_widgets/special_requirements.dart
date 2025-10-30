// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:google_fonts/google_fonts.dart';
// class SpecialRequirements extends StatelessWidget {
//   const SpecialRequirements({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return  Column(
//       children: [
//         Container(
//            height: 83,
//                    // margin: EdgeInsets.symmetric(horizontal: 16),
//                      decoration:const BoxDecoration(
//                        borderRadius: BorderRadius.all(Radius.circular(12)),
                  
//                   boxShadow: [
//                     BoxShadow(
//                       color: Color(0xFFFAFAFA),
//                       offset: Offset(0, 4), // shadow position from bottom
//                       blurRadius: 1,
//                     ),
//                   ],
//                 ),
                    
//                     child: Padding(
//                       padding: const EdgeInsets.only(right: 16,left: 16),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Row(
//                             children: [
//                               SvgPicture.asset("packages/smart_advisor/smart_advisor_assets/images/foldergreen.svg",height: 50,width: 48,),
//                              const SizedBox(
//                                 width: 5,
//                               ),
//                               Text(
//                                 "اشتراطات مختبرات المواد العامه",
//                                style: GoogleFonts.cairo(
//                                     fontSize: 14,
                                    
//                                     color:const Color(0xFF18182D)),
//                               ),
//                             ],
//                           ),
//                           SvgPicture.asset("packages/smart_advisor/smart_advisor_assets/images/ArrowRightt.svg",height: 24,width: 24,),
//                         ],
//                       ),
//                     ),
//         ),

//        const SizedBox(height: 10,),

//                    Container(
//                 height: 83,
//                 //width: 361,
//                 //margin: EdgeInsets.symmetric(horizontal: 16),
//                  decoration:const BoxDecoration(
//                    borderRadius: BorderRadius.all(Radius.circular(12)),
//               boxShadow: [
//                 BoxShadow(
//                   color: Color(0xFFFAFAFA),

//                   offset: Offset(0, 4), // shadow position from bottom
//                   blurRadius: 1,
//                 ),
//               ],
//             ),
//                 child: Padding(
//                   padding: const EdgeInsets.only(right: 16,left: 16),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Expanded(
//                         child: Row(
//                           children: [
//                          SvgPicture.asset("packages/smart_advisor/smart_advisor_assets/images/folderblue.svg",height: 50,width: 48,),
//                            const SizedBox(
//                               width: 5,
//                             ),
//                             Flexible(
//                               child: Text(
//                                 " الاشتراطات البلدية والفنية للمحلات التجارية العامة ",
//                                 style: GoogleFonts.cairo(
//                                     fontSize: 14,
                                   
//                                     color:const Color(0xFF18182D)),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       SvgPicture.asset("packages/smart_advisor/smart_advisor_assets/images/ArrowRightt.svg",height: 24,width: 24,),
//                     ],
//                   ),
//                 ),
//               ),
//       ],
//     );
//   }
// }