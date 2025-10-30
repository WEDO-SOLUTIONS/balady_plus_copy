import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:flutter/material.dart';

class ListItem extends StatelessWidget {
  final String number;
  final String name;
  final Widget page;
  const ListItem({
    super.key,
    required this.number,
    required this.name,
    required this.page,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        NavigationService.navigatorKey.currentState!.push(
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(7),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        width: 343,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  number,
                  style: const TextStyle(
                    color: Color(0xFF3F3F46),
                    fontSize: 15,
                    fontFamily: 'packages/balady_uikit/Frutiger',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  name,
                  style: const TextStyle(
                    color: Color(0xFF3F3F46),
                    fontSize: 15,
                    fontFamily: 'packages/balady_uikit/Frutiger',
                    fontWeight: FontWeight.w700,
                  ),
                )
              ],
            ),
            const Icon(
              Icons.arrow_back_ios_new,
              size: 12,
              color: Color(0xFF292D32),
            ),
          ],
        ),
      ),
    );
  }
}
