import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mapness/features/common/config/package_fonts.dart';

class PersonalData extends StatelessWidget {
  const PersonalData({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        PersonalDataRow(
          title: "Ahmed",
          subtitle: "First name",
        ),
        PersonalDataRow(
          title: "El Usman",
          subtitle: "Last name",
        ),
        PersonalDataRow(
          title: "Ahmed.Usman@gmail.com",
          subtitle: "Email",
        ),
        PersonalDataRow(
          title: "05.04.1978",
          subtitle: "Date of birth",
        ),
        PersonalDataRow(
          title: "أحمد عبده أحمد أفه العثمان",
          subtitle: "Arabic full name",
          isArabic: true,
        ),
        PersonalDataRow(
          title: "Ahmed Abdu Ahmed Avh El Usman",
          subtitle: "English full name",
        ),
        PersonalDataRow(
          title: "Saudi Arabia",
          subtitle: "Nationality",
        ),
      ],
    );
  }
}

class PersonalDataRow extends StatelessWidget {
  const PersonalDataRow({
    super.key,
    required this.title,
    required this.subtitle,
    this.isArabic = false,
  });

  final String title;
  final String subtitle;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 10, bottom: 12, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            title,
            style: isArabic
                ? PackageFonts.frutigerArabic(
                    fontSize: 16,
                    height: 1.4,
                    color: const Color(0xFF1E2A36),
                  )
                : GoogleFonts.inter(
                    fontSize: 16,
                    height: 1.4,
                    color: const Color(0xFF1E2A36),
                  ),
          ),
          Text(
            subtitle,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: const Color(0xB21E2A36),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
