import 'dart:convert';

import '/app/core/utils/common_functions.dart';
import '/app/features/home/home_exports.dart';
import '/app/features/home/presentation/widgets/news_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';

import '../../domain/use_cases/entity_type_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final dio = Dio();
  List<EntityType> types = [];

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: (context) => HomeBloc()..add(const GetNews()),
      child: BlocConsumer<HomeBloc, HomeState>(listener: (_, state) {
        if (state.newsStatus.isFailure) {
          CommonFunctions.showError(state.errorMessage ?? "");
        }
      }, builder: (_, state) {
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [NewsSection()],
            ),
          ),
        );
      }),
    );
  }

  void request() async {
    Response response;
    response = await dio
        .get('https://668a7dbe2c68eaf3211cf1a5.mockapi.io/GetEntityTypes');
    print(response.data);

    types =
        List<EntityType>.from(response.data.map((x) => EntityType.fromJson(x)));

    setState(() {});
    print(response.data.toString());
  }
}
