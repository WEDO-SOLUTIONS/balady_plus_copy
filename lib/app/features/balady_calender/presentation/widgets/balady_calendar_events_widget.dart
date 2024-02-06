import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BaladyCalendarEventsWidget extends StatelessWidget {
  const BaladyCalendarEventsWidget({super.key});


  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      builder: (context, state) {
        return Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text('سبتمبر'), Text('(1)')],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: AppColor.white10,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 10,
                    decoration: const BoxDecoration(
                      color: AppColor.darkRed,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('رخصة تجارية'),
                      Text('انتهاء صلاخية الفاتورة 45891562')
                    ],
                  ),
                  const Spacer(),
                  const Text('الثلاثاء 14'),
                  const SizedBox(width: 10)
                ],
              ),
            ),
            Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text('اكتوبر'), Text('(2)')],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: AppColor.white10,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 10,
                        decoration: const BoxDecoration(
                          color: AppColor.primary700Light,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('رخصة تجارية'),
                          Text('انتهاء صلاخية الفاتورة 45891562')
                        ],
                      ),
                      const Spacer(),
                      const Text('الثلاثاء 14'),
                      const SizedBox(width: 10)
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: AppColor.white10,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 10,
                        decoration: const BoxDecoration(
                            color: AppColor.darkYellow,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(15),
                                bottomRight: Radius.circular(15))),
                      ),
                      const SizedBox(width: 10),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('رخصة تجارية'),
                          Text('انتهاء صلاخية الفاتورة 45891562')
                        ],
                      ),
                      const Spacer(),
                      const Text('الثلاثاء 14'),
                      const SizedBox(width: 10)
                    ],
                  ),
                )
              ],
            ),
          ],
        );
      },
    );
  }
}
