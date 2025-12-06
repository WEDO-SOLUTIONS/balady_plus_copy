import 'package:flutter/material.dart';
import 'package:mapness/entities/iwish/models/iwish_entity.dart';
import 'package:mapness/widgets/iwish/ui/iwish_info.dart';
import 'package:mapness/widgets/iwish/ui/iwish_photos_mutiview.dart';

class IwishCard extends StatelessWidget {
  const IwishCard({
    required this.iwish,
    required this.onClose,
    required this.distance,
    required this.onTap,
    super.key,
  });
  final IwishEntity iwish;
  final String distance;
  final VoidCallback onClose;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PhotosMutiview(photos: iwish.photos),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: IwishInfo(
                    iwish: iwish,
                    distance: distance,
                    onClose: onClose,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
