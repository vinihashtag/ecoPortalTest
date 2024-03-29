import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RoutesApp {
  RoutesApp._();

  static const String movie = '/movie';
  static const String movieDetails = '/movie-details';

  static final routes = [
    GetPage(
      name: RoutesApp.movie,
      page: () => const Scaffold(),
      // binding: MovieBindings(),
    ),
    GetPage(
      name: RoutesApp.movieDetails,
      page: () => const Scaffold(),
      // binding: MovieDetailsBindings(),
      transition: Transition.fade,
    ),
  ];
}
