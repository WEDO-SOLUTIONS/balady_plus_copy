// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ResultWidget extends StatelessWidget {
  const ResultWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 40),
      child: Stack(
        clipBehavior:
            Clip.none, // Allow the circle to extend outside the Stack bounds
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 16, left: 16),
            child: Container(
              height: 215,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Color(0xFFF5EEE9)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    'لديك 3 مخالفات',
                    style: GoogleFonts.cairo(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 12,
                          width: 98,
                          decoration: BoxDecoration(
                            color: Color(0xFFDCC191),
                            borderRadius: BorderRadius.only(
                              // topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                          ),
                        ),
                        Container(
                          height: 12,
                          width: 98,
                          decoration: BoxDecoration(
                            color: Color(0xFFF29900),
                          ),
                        ),
                        Container(
                          height: 12,
                          width: 98,
                          decoration: BoxDecoration(
                            color: Color(0xFFD9D9D9),
                            borderRadius: BorderRadius.only(
                              // topLeft: Radius.circular(10),
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 28.0, left: 28),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                              'قليل',
                              style: GoogleFonts.cairo(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            Text(
                              '0 - 13',
                              style: GoogleFonts.cairo(fontSize: 14),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              'متوسط',
                              style: GoogleFonts.cairo(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            Text(
                              '14 - 26 ',
                              style: GoogleFonts.cairo(fontSize: 14),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              'عالي',
                              style: GoogleFonts.cairo(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            Text(
                              '27- 40',
                              style: GoogleFonts.cairo(fontSize: 14),
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top:
                -40, // Adjust this value to move the circle 20 units above the container
            left: MediaQuery.of(context).size.width / 2 -
                65, // Center horizontally
            child: Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                  color: const Color(0xFFF29900),
                  borderRadius: BorderRadius.circular(50)),
              child: Center(
                child: Text(
                  '23',
                  style: GoogleFonts.cairo(
                      fontSize: 40, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
