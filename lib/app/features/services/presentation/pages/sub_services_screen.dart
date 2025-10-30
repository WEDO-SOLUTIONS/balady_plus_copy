import 'package:balady_plus/app/features/services/domain/entities/services_entity.dart';
import 'package:balady_plus/app/features/services/presentation/cubit/sub_service_cubit/sub_service_cubit.dart';
import 'package:balady_plus/app/features/services/presentation/widgets/sub_services/search%D9%80services_widget.dart';
import 'package:balady_plus/app/features/services/presentation/widgets/sub_services/sub_service_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class SubServicesScreen extends StatelessWidget {
  const SubServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var data = ModalRoute.of(context)!.settings.arguments;
    List<Service> listOfServices = data is List<Service>
        ? data
        : data is Map
            ? data["services"]
            : [];
    return BlocProvider<ServiceCardsCubit>(
      create: (context) => ServiceCardsCubit(listOfServices: listOfServices),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          title: Text("services".tr()),
          centerTitle: true,
          titleTextStyle: Theme.of(context).textTheme.titleLarge,
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          leading: const BackButton(),
        ),
        body: Column(
          children: [
            SearchServicesWidget(autofocus: data is! List<Service>),
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
                    listOfServices = state.listOfServices;
                    return SafeArea(
                      child: ListView.builder(
                        itemCount: listOfServices.length,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return SubServiceItem(service: listOfServices[index]);
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
      ),
    );
  }
}
