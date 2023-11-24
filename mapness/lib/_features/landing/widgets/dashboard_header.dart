import 'package:flutter/material.dart' hide SearchBar;
import 'package:mapness/_features/landing/widgets/favorites.dart';
import 'package:mapness/app/routes/search.dart';
import 'package:mapness/widgets/search/ui/search_field.dart';

class DashboardHeaderDelegate extends SliverPersistentHeaderDelegate {
  DashboardHeaderDelegate({
    required this.draggableScrollableController,
  });

  final DraggableScrollableController draggableScrollableController;

  @override
  Widget build(context, double shrinkOffset, bool overlapsContent) {
    return DashboardHeader(
      draggableScrollableController: draggableScrollableController,
    );
  }

  @override
  double get maxExtent => 132;

  @override
  double get minExtent => 132;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
}

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({
    super.key,
    required this.draggableScrollableController,
  });

  final DraggableScrollableController draggableScrollableController;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16.0),
          topLeft: Radius.circular(16.0),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(
            height: 8,
          ),
          Center(
            child: Container(
              height: 4,
              width: 26,
              decoration: const BoxDecoration(
                color: Color(0xFFDDE4EE),
                borderRadius: BorderRadius.all(Radius.circular(24)),
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: GestureDetector(
              onTap: () {
                const SearchRoute().push(context);
                draggableScrollableController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                );
              },
              child: const AbsorbPointer(
                child: SearchField(),
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          const Favorites(
            background: Color(0x0D1E2A36),
          ),
          const SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }
}
