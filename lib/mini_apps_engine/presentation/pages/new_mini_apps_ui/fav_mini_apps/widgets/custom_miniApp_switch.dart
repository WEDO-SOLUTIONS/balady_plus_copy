import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//!
class CustomMiniAppSwitch extends StatelessWidget {
  final bool isActive;
  final ValueChanged<bool>? onChanged;

  const CustomMiniAppSwitch({super.key, required this.isActive, this.onChanged});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // استخراج الألوان من الثيم مباشرة لتجنب تكرار الأكواد
    final activeTrackColor = theme.primaryColor;
    final activeThumbColor = Colors.white;

    // الألوان في حالة التعطيل بناءً على الثيم المبرمج مسبقاً
    final inactiveTrackColor = isDark ? const Color(0xFF1F2A37) : Colors.white;
    final inactiveThumbColor = isDark ? const Color(0xFF9DA4AE) : const Color(0xFF161616);
    final inactiveBorderColor = isDark ? const Color(0xFF6C737F) : const Color(0xFF161616);

    return GestureDetector(
      onTap: () {
        if (onChanged != null) {
          onChanged!(!isActive);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        // المقاسات هنا مطابقة لنسبة وتناسب الـ Figma (يمكنك تعديلها قليلاً لو أحببت)
        width: 60,
        height: 38,
        padding: const EdgeInsets.all(1), // المسافة بين الدائرة والحدود
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isActive ? activeTrackColor : inactiveTrackColor,
          border: Border.all(
            color: isActive ? Colors.transparent : inactiveBorderColor,
            width: 1.5, // سمك الحدود في حالة عدم التفعيل
          ),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          // AlignmentDirectional تضمن أن السويتش يمين/يسار ينعكس تلقائياً في اللغة العربية
          alignment: isActive ? AlignmentDirectional.centerEnd : AlignmentDirectional.centerStart,
          child: Container(
            width: 30, // حجم الدائرة الداخلية
            height: 50,
            decoration: BoxDecoration(shape: BoxShape.circle, color: isActive ? activeThumbColor : inactiveThumbColor),
          ),
        ),
      ),
    );
  }
}
