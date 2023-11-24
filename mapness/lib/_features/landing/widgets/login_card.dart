import 'package:flutter/material.dart';
import 'package:mapness/shared/config/package_fonts.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class LoginCard extends StatelessWidget {
  const LoginCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Material(
        child: Ink.image(
          image: const AssetImage(
            "assets/images/login.png",
            package: PackageConfig.packageName,
          ),
          fit: BoxFit.cover,
          child: InkWell(
            onTap: () {},
            child: SizedBox(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 24,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Spacer(),
                        Text(
                          context.l10n.signIn,
                          style: PackageFonts.frutigerArabic(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            height: 1.5,
                          ),
                        ),
                        Text(
                          context.l10n.inNovember,
                          style: PackageFonts.frutigerArabic(
                            color: Colors.white.withOpacity(0.8),
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(
                          height: 13,
                        ),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                      child: Text(
                        context.l10n.signIn,
                        textAlign: TextAlign.center,
                        style: PackageFonts.frutigerArabic(
                          color: const Color(0xFF4CA5B4),
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          height: 1.4,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
