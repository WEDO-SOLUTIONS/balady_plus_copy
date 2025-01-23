import 'package:balady_plus/app/features/services/core/help_function.dart';
import 'package:balady_plus/app/features/services/domain/entities/services_entity.dart';
import 'package:balady_plus/app/features/services/presentation/cubit/home_services_cubit/home_services_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeatureServiceItem extends StatelessWidget {
  final Service service;

  const FeatureServiceItem({
    super.key,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // HomeServicesCubit homeServicesCubit = context.read<HomeServicesCubit>();
        // homeServicesCubit.
        checkIfLogin(context, service);
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.31,
        height: double.maxFinite,
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/constructions.png"),
              fit: BoxFit.cover,
            ),
          ),
          margin: const EdgeInsetsDirectional.only(end: 12),
          // color: const Color(0xff9547E9),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              service.title,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
