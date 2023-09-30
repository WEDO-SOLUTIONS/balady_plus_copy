import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';

import '../../calendar_exports.dart'
    show SectionDate, SectionContainer, NationalDay;

class MainPageCalendar extends StatelessWidget {
  const MainPageCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          height: 135,
          color: Colors.white,
        ),
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            SectionDate(
              month: 'سبتمبر',
              year: '2023',
            ),
            SectionContainer(
              name: 'حساب المواطن',
              date: '25 / 2 / 1445 هـ - 10 / 9 / 2023 م',
              day: '10',
              month: 'سبتمبر',
              color1: Color(0xFF65C1C0),
              color2: Color(0xFFA6D377),
              timer: "٢٣ يوم : ٢١ س : ١٩ د",
            ),
            SectionContainer(
              name: 'الضمان',
              date: '25 / 2 / 1445 هـ - 10 / 9 / 2023 م',
              day: '20',
              month: 'سبتمبر',
              color1: Color(0xFFD48C82),
              color2: Color(0xFFE7B366),
              timer: "٢٣ يوم : ٢١ س: ١٩ د",
            ),
            SectionContainer(
              name: 'رواتب المتقاعدين',
              date: '25 / 2 / 1445 هـ - 10 / 9 / 2023 م',
              day: '25',
              month: 'سبتمبر',
              color1: Color(0xFF6090B9),
              color2: Color(0xFF67C2D2),
              timer: "٢٣ يوم : ٢١ س : ١٩ د",
            ),
            SectionContainer(
              name: 'اليوم الوطني',
              date: '25 / 2 / 1445 هـ - 10 / 9 / 2023 م',
              day: '30',
              month: 'سبتمبر',
              color1: Color(0xFF0A7E47),
              color2: Color(0xFF3AB379),
              timer: "٢٣ يوم : ٢١ س : ١٩ د",
              imageBackground: ImagePath.calendarNationalDay,
            ),
            SectionDate(
              month: 'اكتوبر',
              year: '2023',
            ),
            SectionContainer(
              name: 'حساب المواطن',
              date: '25 / 2 / 1445 هـ - 10 / 9 / 2023 م',
              day: '10',
              month: 'سبتمبر',
              color1: Color(0xFF65C1C0),
              color2: Color(0xFFA6D377),
              timer: "٢٣ يوم : ٢١ س : ١٩ د",
            ),
            SectionContainer(
              name: 'الضمان',
              date: '25 / 2 / 1445 هـ - 10 / 9 / 2023 م',
              day: '20',
              month: 'سبتمبر',
              color1: Color(0xFFD48C82),
              color2: Color(0xFFE7B366),
              timer: "٢٣ يوم : ٢١ س : ١٩ د",
            ),
          ],
        ),
      ),
    );
  }
}
