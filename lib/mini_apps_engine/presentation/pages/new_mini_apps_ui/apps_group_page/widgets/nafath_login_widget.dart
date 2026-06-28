import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/keys/general_keys.dart';
import 'package:flutter/material.dart';

//!
class NafathLoginWidget extends StatelessWidget {
  const NafathLoginWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: shapeDecoration,
      child: Row(
        spacing: 12,
        children: [
          Expanded(
            flex: 4,
            child: Column(spacing: 6, crossAxisAlignment: CrossAxisAlignment.start, children: [...info, action]),
          ),
          Expanded(flex: 2, child: nafathImage),
        ],
      ),
    );
  }

  BoxDecoration get shapeDecoration => BoxDecoration(
    color: Color(0XFF005937),
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(color: Color(0x14000000), blurRadius: 4, offset: Offset(0, 1), spreadRadius: 0),
      BoxShadow(color: Color(0x0A000000), blurRadius: 0, offset: Offset(0, 0), spreadRadius: 0.50),
    ],
  );

  List<Widget> get info => [
    Text(
      CommonFunctions.isAppAR ? 'تابع إحصائياتك الشخصية' : 'Track your personal statistics',
      style: TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w700,
        height: 1.50,
        fontFamily: GeneralKey.appFontType,
      ),
    ),
    Text(
      CommonFunctions.isAppAR ? 'سجل الدخول عبر نفاذ لعرض لوحة البيانات' : 'Login via Nafath to view the dashboard',
      style: TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.25,
        fontFamily: GeneralKey.appFontType,
      ),
    ),
  ];

  Widget get action => ElevatedButton(
    onPressed: () async {
      final isLoggedIn = await CommonFunctions.onLogin(isMunicipality: true);
      if (isLoggedIn) {
        // The parent widget will automatically rebuild due to CommonProperties.isLoggedInMunicipality change
        // No additional action needed as the widget tree will update automatically
      }
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0XFFF3F4F6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      minimumSize: const Size(0, 36),
    ),
    child: Text(
      CommonFunctions.isAppAR ? 'التحقق عبر نفاذ' : 'Verify via Nafath',
      style: TextStyle(
        color: Color(0XFF161616),
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.43,
        fontFamily: GeneralKey.appFontType,
      ),
    ),
  );

  Widget get nafathImage => Image.asset("assets/images/nafath_login_image.png", fit: BoxFit.contain);
}
