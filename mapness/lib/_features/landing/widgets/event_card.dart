import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_uikit/core/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  const EventCard({
    required this.title, required this.subtitle, required this.imageUrl, required this.id, super.key,
  });

  final String title;
  final String subtitle;
  final String imageUrl;
  final String id;

  @override
  Widget build(BuildContext context) => ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Material(
        child: Ink.image(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
          child: InkWell(
            onTap: () {
              NavigationService.navigatorKey.currentState!.pushNamed(
                RouteName.eventsDetailsPage,
                arguments: id,
              );
            },
            child: SizedBox(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(),
                    Text(
                      title,
                      style: Theme.of(context)
                          .extension<ThemeTextStyles>()!
                          .heading2
                          .copyWith(color: Colors.white),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Text(
                      subtitle,
                      style: Theme.of(context)
                          .extension<ThemeTextStyles>()!
                          .footNote
                          .copyWith(color: Colors.white.withOpacity(0.8)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
}
