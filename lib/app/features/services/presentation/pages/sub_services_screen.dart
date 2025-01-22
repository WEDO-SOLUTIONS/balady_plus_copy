import 'package:balady_plus/app/features/services/domain/entities/services_entity.dart';
import 'package:balady_plus/app/features/services/presentation/widgets/sub_services/sub_service_item.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class SubServicesScreen extends StatelessWidget {
  const SubServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<Service> listOfServices =
        ModalRoute.of(context)!.settings.arguments as List<Service>;

    return Scaffold(
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
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: "search".tr(),
                filled: true,
                fillColor: Colors.grey.shade200,
                prefixIcon: const Icon(
                  Icons.search,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          //////////////////////////////////////////////////////
          const SizedBox(height: 8),
          Expanded(
            child: SafeArea(
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
            ),
          ),
          const SizedBox(height: 8),
          //////////////////////////////////////////////////////
          //////////////////////////////////////////////////////
          //////////////////////////////////////////////////////
        ],
      ),
    );
  }
}
