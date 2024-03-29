import 'dart:io';

import 'package:coolmovies/shared/stores/connectivity_store.dart';
import 'package:coolmovies/shared/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'shared/routes/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Cool Movies',
      debugShowCheckedModeBanner: false,
      initialBinding: MainBindings(),
      theme: AppTheme.defaultTheme,
      getPages: RoutesApp.routes,
      initialRoute: RoutesApp.movie,
    );
  }
}

class MainBindings implements Bindings {
  @override
  void dependencies() {
    final HttpLink httpLink =
        HttpLink(Platform.isAndroid ? 'http://10.0.2.2:5001/graphql' : 'http://localhost:5001/graphql');

    Get.put(GraphQLClient(link: httpLink, cache: GraphQLCache(store: InMemoryStore())), permanent: true);

    Get.put(ConnectivityStore(), permanent: true);
  }
}
