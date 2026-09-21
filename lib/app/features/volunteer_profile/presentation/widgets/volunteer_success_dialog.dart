import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class VolunteerSuccessDialog extends StatelessWidget {
  final VoidCallback? onNavigateToServices;

  const VolunteerSuccessDialog({
    super.key,
    this.onNavigateToServices,
  });

  @override
  Widget build(BuildContext context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Success illustration
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.teal.shade100,
                        Colors.teal.shade50,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(60),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Checklist illustration
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Lines representing a checklist
                          Container(
                            width: 60,
                            height: 3,
                            margin: const EdgeInsets.only(bottom: 4),
                            decoration: BoxDecoration(
                              color: Colors.teal.shade300,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          Container(
                            width: 45,
                            height: 3,
                            margin: const EdgeInsets.only(bottom: 4),
                            decoration: BoxDecoration(
                              color: Colors.teal.shade300,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          Container(
                            width: 55,
                            height: 3,
                            margin: const EdgeInsets.only(bottom: 4),
                            decoration: BoxDecoration(
                              color: Colors.teal.shade300,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          Container(
                            width: 40,
                            height: 3,
                            decoration: BoxDecoration(
                              color: Colors.teal.shade300,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ],
                      ),
                      // Success checkmark
                      Positioned(
                        bottom: 20,
                        right: 15,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.teal.shade600,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Success title
                Text(
                  'volunteer_profile_success_title'.tr(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),

                // Success subtitle
                Text(
                  'volunteer_profile_success_subtitle'.tr(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),

                // Action button
                SizedBox(
                  width: double.infinity,
                  height: 64,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onNavigateToServices?.call();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00796B),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'volunteer_services_button'.tr(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
   
                // Skip button
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'skipButton'.tr(),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

// Function to show the success dialog
Future<void> showVolunteerSuccessDialog(
  BuildContext context, {
  VoidCallback? onNavigateToServices,
}) async =>
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => VolunteerSuccessDialog(
        onNavigateToServices: onNavigateToServices,
      ),
    );
