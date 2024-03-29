import 'package:coolmovies/data/repositories/review/review_repository.dart';
import 'package:coolmovies/data/repositories/review/review_repository_interface.dart';

import 'movie_details_controller.dart';
import 'package:get/get.dart';

class MovieDetailsBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IReviewRepository>(() => ReviewRepository(Get.find()));
    Get.lazyPut(() => MovieDetailsController(Get.arguments['movie'], Get.find(), Get.find()));
  }
}
