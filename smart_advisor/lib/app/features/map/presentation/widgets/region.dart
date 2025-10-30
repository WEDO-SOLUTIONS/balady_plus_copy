import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/app/features/shared_features/widgets/app_bar.dart';
import '/app/features/shared_features/widgets/custom_button.dart';

class Region extends StatelessWidget {
  const Region({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F7FC),
        appBar: const CustomAppBar(title: "المساحة"),
        body: Padding(
          padding: const EdgeInsets.only(right: 16, left: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 25,
              ),
              Text(
                'ما هي مساحة الفرضية الخاصة بك؟',
                style: GoogleFonts.cairo(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'قم باختيار نوع المنشأة الذي ترغب في الاستعلام عنه من القائمة.',
                style: GoogleFonts.cairo(
                    fontSize: 16, color: const Color(0xFF566069)),
              ),
              const SizedBox(
                height: 25,
              ),
              Container(
                height: 52,
                decoration: BoxDecoration(
                    color: const Color.fromARGB(136, 229, 225, 225),
                    borderRadius: BorderRadius.circular(24)),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 163,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                        "packages/smart_advisor/smart_advisor_assets/images/store.png"),
                    const SizedBox(
                      width: 60,
                    ),
                    Column(
                      children: [
                        const SizedBox(
                          height: 45,
                        ),
                        Text(
                          '24 - 100 m',
                          style: GoogleFonts.cairo(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF566069)),
                        ),
                        Text(
                          'محل صغير',
                          style: GoogleFonts.cairo(
                              fontSize: 16, color: const Color(0xFF566069)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 163,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                        "packages/smart_advisor/smart_advisor_assets/images/largeStore.png"),
                    const SizedBox(
                      width: 60,
                    ),
                    Column(
                      children: [
                        const SizedBox(
                          height: 45,
                        ),
                        Text(
                          '100 - 150 m',
                          style: GoogleFonts.cairo(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF566069)),
                        ),
                        Text(
                          'محل كبير ',
                          style: GoogleFonts.cairo(
                              fontSize: 16, color: const Color(0xFF566069)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              CustomButton(onPress: () {}, text: 'التالي')
            ],
          ),
        ),
      ),
    );
  }
}
