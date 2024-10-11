import '/app/core/utils/constants/language.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

class EvaluationRusltPage extends StatelessWidget {
  const EvaluationRusltPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(right: 40, left: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SpinKitCircle(
                size: 100,
                duration: const Duration(seconds: 1),
                itemBuilder: (context, index) {
                  final colors = [
                    const Color(0xFF2E7998),
                    const Color(0xFFD5DDD9)
                  ];
                  final color = colors[index % colors.length];
                  return DecoratedBox(
                      decoration:
                          BoxDecoration(color: color, shape: BoxShape.circle));
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                ("questions_over").tr(),
                style: GoogleFonts.cairo(
                    fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                ("waiting_result").tr(),
                textAlign: TextAlign.center,
                style: GoogleFonts.cairo(
                  //height: 1.8,
                  fontSize: 16,
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              Text(
                ("conduct_another_evaluation").tr(),
                textAlign: TextAlign.center,
                style: GoogleFonts.cairo(
                  // height: 1.8,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
