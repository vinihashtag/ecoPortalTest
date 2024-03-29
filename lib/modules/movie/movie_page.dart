import 'package:coolmovies/shared/animations/animate_do_zooms.dart';
import 'package:coolmovies/shared/errors/no_connection_error.dart';
import 'package:coolmovies/shared/extensions/date_extension.dart';
import 'package:coolmovies/shared/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../shared/animations/animate_do_fades.dart';
import '../../shared/widgets/custom_error_widget.dart';
import '../../shared/widgets/custom_image_widget.dart';
import 'movie_controller.dart';

class MoviePage extends GetView<MovieController> {
  const MoviePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ZoomIn(
          delay: const Duration(microseconds: 500),
          child: const Text('Cool Movies'),
        ),
      ),
      body: Obx(
        () {
          if (controller.statusScreen.isLoading || controller.statusScreen.isInitial) {
            return const LinearProgressIndicator();
          }

          if (controller.statusScreen.isFailure) {
            return CustomErrorWidget(
              text: 'Error on get all movies, please try again.',
              onPressed: controller.getMovies,
            );
          }

          if (controller.statusScreen.isNoConnection) {
            return CustomErrorWidget(
              text: NoConnectionError.text,
              onPressed: controller.getMovies,
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 16),
            itemCount: controller.movies.length,
            separatorBuilder: (context, index) => Divider(color: Colors.grey.shade300, indent: 18, endIndent: 18),
            itemBuilder: (context, index) {
              final movie = controller.movies[index];
              return FadeInDown(
                duration: const Duration(milliseconds: 450),
                child: ListTile(
                  onTap: () => Get.toNamed(RoutesApp.movieDetails, arguments: {'movie': movie}),
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    clipBehavior: Clip.hardEdge,
                    child: Hero(
                      tag: movie.id,
                      child: CustomImageWidget(
                        imageUrl: movie.imgUrl,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  title: Text(
                    movie.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      height: 1.1,
                    ),
                  ),
                  subtitle: Text('Released on: ${movie.releaseDate.formatddMMyyyy}'),
                  trailing: Icon(Icons.arrow_forward_ios_rounded, color: Colors.blue.shade300),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
