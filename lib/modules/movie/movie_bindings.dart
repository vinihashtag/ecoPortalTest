import 'package:coolmovies/data/repositories/movie/movie_repository.dart';
import 'package:coolmovies/data/repositories/movie/movie_repository_interface.dart';

import 'movie_controller.dart';
import 'package:get/get.dart';

class MovieBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IMovieRepository>(() => MovieRepository(Get.find()));
    Get.lazyPut(() => MovieController(Get.find(), Get.find()));
  }
}
