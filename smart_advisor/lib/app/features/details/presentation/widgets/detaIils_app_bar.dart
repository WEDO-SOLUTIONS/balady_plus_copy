import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_advisor/app/core/utils/constants/language.dart';

import '../../../../core/services/local/navigation_services.dart';
import '../bloc/details_bloc.dart';
import '../bloc/details_event.dart';
import '../bloc/details_state.dart';
import '/app/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DetailsAppBar extends StatefulWidget {
  final Function(int index) onSegmentBasic;
  const DetailsAppBar({super.key, required this.onSegmentBasic});

  @override
  State<DetailsAppBar> createState() => _DetailsAppBarState();
}

class _DetailsAppBarState extends State<DetailsAppBar> {
  int _selectedIndexBasic = 0;
  // bool isViewDetail = false;

  void _onSegmentBasic(int index) {
    setState(() {
      _selectedIndexBasic = index;
    });
    widget.onSegmentBasic(index);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 195,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05), // Black color with 5% opacity
          offset: const Offset(0, 4), // X = 0, Y = 4
          blurRadius: 24, // Blur radius of 24
          spreadRadius: 0, // Spread radius of 0
        ),
      ], color: AppColor.white),
      child: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
          bottom: 12,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    NavigationService.navigatorKey.currentState!.pop(context);
                  },
                  icon: SvgPicture.asset(
                    IconPath.backIcon,
                    width: 12,
                    color: AppColor.black, //statusAccentColor,
                  ),
                ),
                Flexible(
                  child: Text("التفاصيل",
                      maxLines: 1, style: AppStyle.calloutBoldStyle),
                ),
                const SizedBox(
                  width: 40,
                ),
              ],
            ),
            Container(
              height: 72,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(right: 16),
                scrollDirection: Axis.horizontal,
                child: Row(children: <Widget>[
                  BlocBuilder<DetailsBloc, DetailsState>(
                    buildWhen: (previous, current) =>
                        previous.entityActivityDetailsStatus !=
                        current.entityActivityDetailsStatus,
                    builder: (context, state) {
                      return GestureDetector(
                        onTap: () {
                          context
                              .read<DetailsBloc>()
                              .add(GetEntityActivityDetailsEvent());

                          _onSegmentBasic(0);
                        },
                        child: Container(
                          width: 140,
                          height: 50,
                          alignment: Alignment.center,
                          margin: const EdgeInsetsDirectional.only(end: 12),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 14),
                          decoration: BoxDecoration(
                              color: _selectedIndexBasic == 0
                                  ? AppColor.statusAccentColor
                                  : AppColor.grey1,
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(10.0))),
                          child: Text(("activity_info").tr(),
                              style: _selectedIndexBasic == 0
                                  ? AppStyle.footNoteBoldStyle.copyWith(
                                      color: _selectedIndexBasic == 0
                                          ? AppColor.white
                                          : AppColor.textSecondaryColor)
                                  : AppStyle.textRegularRomanStyle.copyWith(
                                      color: _selectedIndexBasic == 0
                                          ? AppColor.white
                                          : AppColor.textSecondaryColor)),
                        ),
                      );
                    },
                  ),
                  BlocBuilder<DetailsBloc, DetailsState>(
                    buildWhen: (previous, current) =>
                        previous.regulationStatus != current.regulationStatus,
                    builder: (context, state) {
                      return GestureDetector(
                          onTap: () {
                            context
                                .read<DetailsBloc>()
                                .add(GetRegulationsEvent());
                            _onSegmentBasic(1);
                          },
                          child: Container(
                              width: 140,
                              height: 50,
                              alignment: Alignment.center,
                              margin: const EdgeInsetsDirectional.only(end: 12),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 14),
                              decoration: BoxDecoration(
                                  color: _selectedIndexBasic == 1
                                      ? AppColor.statusAccentColor
                                      : AppColor.grey1,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10.0))),
                              child: Text(
                                ("requirements").tr(),
                                style: _selectedIndexBasic == 1
                                    ? AppStyle.footNoteBoldStyle.copyWith(
                                        color: _selectedIndexBasic == 1
                                            ? AppColor.white
                                            : AppColor.textSecondaryColor,
                                      )
                                    : AppStyle.textRegularRomanStyle.copyWith(
                                        color: _selectedIndexBasic == 1
                                            ? AppColor.white
                                            : AppColor.textSecondaryColor,
                                      ),
                              )));
                    },
                  ),
                  /*  GestureDetector(
                              onTap: () => _onSegmentBasic(2),
                              child: Container(
                                margin: const EdgeInsetsDirectional.only(end: 5),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 14),
                                decoration: BoxDecoration(
                                    color: _selectedIndexBasic == 2
                                        ? AppColor.statusAccentColor
                                        : AppColor.surfaceTertairyColor,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10.0))),
                                child: Text(
                                  ("self_evaluation").tr(),
                                  style: AppStyle.footNoteBoldStyle.copyWith(
                                    color: _selectedIndexBasic == 2
                                        ? AppColor.white
                                        : AppColor.textSecondaryColor,
                                  ),
                                ),
                              ),
                            ),*/
                  BlocBuilder<DetailsBloc, DetailsState>(
                    builder: (context, state) {
                      return GestureDetector(
                          onTap: () {
                            context
                                .read<DetailsBloc>()
                                .add(GetViolationsListEvent());

                            _onSegmentBasic(2);
                          },
                          child: Container(
                              width: 140,
                              height: 50,
                              alignment: Alignment.center,
                              margin: const EdgeInsetsDirectional.only(end: 12),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 14),
                              decoration: BoxDecoration(
                                  color: _selectedIndexBasic == 2
                                      ? AppColor.statusAccentColor
                                      : AppColor.grey1,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10.0))),
                              child: Text(
                                ('violations').tr(),
                                style: _selectedIndexBasic == 2
                                    ? AppStyle.footNoteBoldStyle.copyWith(
                                        color: _selectedIndexBasic == 2
                                            ? AppColor.white
                                            : AppColor.textSecondaryColor,
                                      )
                                    : AppStyle.textRegularRomanStyle.copyWith(
                                        color: _selectedIndexBasic == 2
                                            ? AppColor.white
                                            : AppColor.textSecondaryColor,
                                      ),
                              )));
                    },
                  ),
                  BlocBuilder<DetailsBloc, DetailsState>(
                    builder: (context, state) {
                      return GestureDetector(
                          onTap: () {
                            print("JJJ");
                            _onSegmentBasic(3);
                            try {
                              context.read<DetailsBloc>().add(GetViolationVD());
                            } catch (ex) {
                              print(ex);
                            }
                          },
                          child: Container(
                              width: 140,
                              height: 50,
                              alignment: Alignment.center,
                              margin: const EdgeInsetsDirectional.only(end: 12),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 14),
                              decoration: BoxDecoration(
                                  color: _selectedIndexBasic == 3
                                      ? AppColor.statusAccentColor
                                      : AppColor.grey1,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10.0))),
                              child: Text(
                                "التشوه البصري",
                                style: _selectedIndexBasic == 3
                                    ? AppStyle.footNoteBoldStyle.copyWith(
                                        color: _selectedIndexBasic == 3
                                            ? AppColor.white
                                            : AppColor.textSecondaryColor,
                                      )
                                    : AppStyle.textRegularRomanStyle.copyWith(
                                        color: _selectedIndexBasic == 3
                                            ? AppColor.white
                                            : AppColor.textSecondaryColor,
                                      ),
                              )));
                    },
                  ),
                  BlocBuilder<DetailsBloc, DetailsState>(
                    builder: (context, state) {
                      return GestureDetector(
                          onTap: () {
                            print("JJJ");
                            _onSegmentBasic(4);
                            context
                                .read<DetailsBloc>()
                                .getComplinaceData(context);
                            try {} catch (ex) {
                              print(ex);
                            }
                          },
                          child: Container(
                              width: 140,
                              height: 50,
                              alignment: Alignment.center,
                              margin: const EdgeInsetsDirectional.only(end: 12),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 14),
                              decoration: BoxDecoration(
                                  color: _selectedIndexBasic == 4
                                      ? AppColor.statusAccentColor
                                      : AppColor.grey1,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10.0))),
                              child: Text(
                                "شهادة الإمتثال",
                                style: _selectedIndexBasic == 4
                                    ? AppStyle.footNoteBoldStyle.copyWith(
                                        color: _selectedIndexBasic == 4
                                            ? AppColor.white
                                            : AppColor.textSecondaryColor,
                                      )
                                    : AppStyle.textRegularRomanStyle.copyWith(
                                        color: _selectedIndexBasic == 4
                                            ? AppColor.white
                                            : AppColor.textSecondaryColor,
                                      ),
                              )));
                    },
                  ),
                  /* GestureDetector(
                              onTap: () => _onSegmentBasic(5),
                              child: Container(
                                margin: const EdgeInsetsDirectional.only(end: 5),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 14),
                                decoration: BoxDecoration(
                                    color: _selectedIndexBasic == 5
                                        ? AppColor.statusAccentColor
                                        : AppColor.surfaceTertairyColor,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10.0))),
                                child: Text(
                                  ("opportunities").tr(),
                                  style: AppStyle.footNoteBoldStyle.copyWith(
                                    color: _selectedIndexBasic == 5
                                        ? AppColor.white
                                        : AppColor.textSecondaryColor,
                                  ),
                                ),
                              ),
                            ),*/
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
