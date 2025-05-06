import 'package:balady_plus/app/features/services/presentation/cubit/sub_service_cubit/sub_service_cubit.dart';
import 'package:balady_plus/app/features/services/presentation/widgets/home_services/mini_apps_item_widget.dart';
import 'package:balady_plus/app/features/services/presentation/widgets/sub_services/search%D9%80services_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MiniAppsSearchScreen extends StatelessWidget {
  const MiniAppsSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          const SearchServicesWidget(autofocus: false),
          //////////////////////////////////////////////////////
          const SizedBox(height: 8), //
          Expanded(
            child: BlocBuilder<ServiceCardsCubit, SubServiceState>(
              builder: (context, state) {
                if (state is ErrorSubServiceState) {
                  return Center(
                    child: Text(state.message),
                  );
                }
                if (state is LoadedSubServiceState) {
                  return SafeArea(
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: .9,
                      ),
                      itemCount: state.listOfServices.length,
                      itemBuilder: (BuildContext context, int index) {
                        return MiniAppsItemWidget(
                          service: state.listOfServices[index],
                        );
                      },
                    ),
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }
}
