import 'package:coolmovies/data/models/review_model.dart';
import 'package:coolmovies/shared/widgets/custom_error_widget.dart';
import 'package:coolmovies/shared/errors/no_connection_error.dart';
import 'package:coolmovies/shared/extensions/date_extension.dart';
import 'package:coolmovies/shared/utils/custom_snackbar.dart';
import 'package:coolmovies/shared/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:get/get.dart';

import '../../shared/animations/animate_do_fades.dart';
import '../../shared/widgets/custom_image_widget.dart';
import 'movie_details_controller.dart';

class MovieDetailsPage extends GetView<MovieDetailsController> {
  const MovieDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: CustomScrollView(
        controller: controller.scrollController,
        physics: const ClampingScrollPhysics(),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        slivers: [
          // * AppBar Custom
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            forceElevated: true,
            title: Obx(
              () => Visibility(
                visible: controller.isVisibleTitle,
                child: FadeInRight(
                  duration: const Duration(milliseconds: 600),
                  child: Text(controller.movie.title, maxLines: 2),
                ),
              ),
            ),
            elevation: 2,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(bottom: 8),
              collapseMode: CollapseMode.parallax,
              background: Hero(
                tag: controller.movie.id,
                child: Container(
                  decoration: const BoxDecoration(),
                  foregroundDecoration: const BoxDecoration(color: Colors.black26),
                  clipBehavior: Clip.hardEdge,
                  child: CustomImageWidget(
                    imageUrl: controller.movie.imgUrl,
                    width: size.width * .9,
                    height: size.width * .9,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),

          // * Infos about movie
          SliverToBoxAdapter(
            child: ListTile(
              title: Text(
                controller.movie.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue,
                  height: 1.2,
                ),
              ),
              subtitle: Text('Released on: ${controller.movie.releaseDate.formatddMMyyyy}'),
            ),
          ),

          // * Title Review
          SliverToBoxAdapter(
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              dense: true,
              title: const Text(
                'Assessments',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black54),
              ),
              subtitle: Divider(color: Colors.grey.shade300, height: 4),
            ),
          ),

          // * List of reviewers
          Obx(
            () {
              if (controller.statusScreen.isLoading) {
                return const SliverToBoxAdapter(child: LinearProgressIndicator());
              }
              if (controller.statusScreen.isNoConnection) {
                return SliverToBoxAdapter(
                  child: CustomErrorWidget(
                    text: NoConnectionError.text,
                    background: Colors.grey.shade300,
                    onPressed: controller.getAllReviewsByMovie,
                  ),
                );
              }
              return SliverList.builder(
                itemCount: controller.reviews.length,
                itemBuilder: (context, index) {
                  final ReviewModel review = controller.reviews[index];
                  return FadeInUp(
                    duration: const Duration(milliseconds: 400),
                    delay: const Duration(milliseconds: 300),
                    child: Card(
                      surfaceTintColor: Colors.grey.shade100,
                      elevation: 1,
                      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                      child: ListTile(
                        dense: true,
                        contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        title: Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  review.title,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: RatingStars(
                                  value: review.rating.toDouble(),
                                  starBuilder: (index, color) => Icon(Icons.star, color: color),
                                  starCount: 5,
                                  starSize: 18,
                                  valueLabelColor: const Color(0xff9b9b9b),
                                  valueLabelTextStyle:
                                      const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12),
                                  valueLabelRadius: 5,
                                  maxValue: 5,
                                  starSpacing: 2,
                                  maxValueVisibility: false,
                                  valueLabelVisibility: true,
                                  animationDuration: const Duration(milliseconds: 1000),
                                  valueLabelPadding: const EdgeInsets.symmetric(vertical: 1.5, horizontal: 8),
                                  valueLabelMargin: const EdgeInsets.only(top: 8, right: 8),
                                  starOffColor: const Color(0xffe7e8ea),
                                  starColor: Colors.yellow,
                                ),
                              ),
                            ],
                          ),
                        ),
                        minVerticalPadding: 5,
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(review.body),
                            Visibility(
                              visible: review.userReviewerId == controller.idUserMock,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  child: SizedBox(
                                    height: 30,
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        if (Get.isSnackbarOpen) Get.closeAllSnackbars();
                                        Get.dialog(
                                          FadeIn(
                                            child: AlertDialog(
                                              title: const Text(
                                                'Are you sure?',
                                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                              ),
                                              content: const Text(
                                                'Do you really want to delete your review?',
                                                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: Get.back,
                                                  child: const Text('CANCEL'),
                                                ),
                                                ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: AppTheme.primaryColor,
                                                    foregroundColor: Colors.white,
                                                  ),
                                                  onPressed: () async {
                                                    final result = await controller.deleteReview(review);
                                                    if (result.isError) {
                                                      CustomSnackbar.showMessageError(message: result.error);
                                                    } else if (result.isSuccess) {
                                                      Get.back();
                                                      CustomSnackbar.showMessageSuccess(
                                                          title: 'Deleted Review',
                                                          message: 'Your review was deleted with successfull!');
                                                    }
                                                  },
                                                  child: const Text('CONFIRM'),
                                                ),
                                              ],
                                            ),
                                          ),
                                          barrierDismissible: false,
                                        );
                                      },
                                      icon: const Icon(Icons.delete, color: Colors.white),
                                      label: const Text('DELETE', style: TextStyle(fontWeight: FontWeight.bold)),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.only(left: 8, right: 12),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),

          // * Button to create a review
          Obx(
            () => SliverVisibility(
              visible: !controller.statusScreen.isNoConnection && !controller.statusScreen.isLoading,
              sliver: SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    onPressed: () async {
                      if (Get.isSnackbarOpen) Get.closeAllSnackbars();
                      await Get.bottomSheet(
                        Material(
                          surfaceTintColor: Colors.white,
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                          child: SingleChildScrollView(
                            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    const Expanded(
                                      child: Text(
                                        'New Review',
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: Get.back,
                                        icon: const Icon(Icons.close, color: AppTheme.disableColor))
                                  ],
                                ),
                                const Text(
                                  'Your Note:',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Obx(
                                  () => RatingStars(
                                    value: controller.rating.toDouble(),
                                    starBuilder: (index, color) => Icon(Icons.star, color: color),
                                    starCount: 5,
                                    starSize: 30,
                                    valueLabelColor: const Color(0xff9b9b9b),
                                    valueLabelTextStyle:
                                        const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12),
                                    valueLabelRadius: 5,
                                    maxValue: 5,
                                    starSpacing: 0,
                                    maxValueVisibility: false,
                                    valueLabelVisibility: true,
                                    animationDuration: const Duration(milliseconds: 350),
                                    valueLabelPadding: const EdgeInsets.symmetric(vertical: 1.5, horizontal: 8),
                                    valueLabelMargin: const EdgeInsets.only(right: 8),
                                    starOffColor: const Color(0xffe7e8ea),
                                    starColor: Colors.yellow,
                                    onValueChanged: (value) {
                                      controller.rating = value;
                                      if (!controller.titleFocus.hasFocus && !controller.descriptionFocus.hasFocus) {
                                        0.2.delay(controller.titleFocus.requestFocus);
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  'Title:',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Obx(
                                  () => TextFormField(
                                    focusNode: controller.titleFocus,
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    onTapOutside: (event) => controller.titleFocus.unfocus(),
                                    enabled: controller.rating > 0,
                                    maxLength: 50,
                                    onChanged: (value) => controller.reviewTitleText = value,
                                    decoration: InputDecoration(
                                      hintText: 'Did you like this movie?',
                                      fillColor: controller.rating > 0 ? Colors.white24 : Colors.grey.shade200,
                                    ),
                                    textCapitalization: TextCapitalization.sentences,
                                    autocorrect: false,
                                    validator: (String? value) =>
                                        (value?.trim() ?? '').length < 3 ? 'Put a valid title for review' : null,
                                    onEditingComplete: () => controller.reviewDescriptionText.trim().isEmpty
                                        ? controller.descriptionFocus.requestFocus()
                                        : controller.titleFocus.unfocus(),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  'Review:',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Obx(
                                  () => TextFormField(
                                    focusNode: controller.descriptionFocus,
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    enabled: controller.rating > 0,
                                    maxLength: 400,
                                    maxLines: 5,
                                    onTapOutside: (event) => controller.descriptionFocus.unfocus(),
                                    onChanged: (value) => controller.reviewDescriptionText = value,
                                    decoration: InputDecoration(
                                      hintText: 'Talk about this movie...',
                                      fillColor: controller.rating > 0 ? Colors.white24 : Colors.grey.shade200,
                                    ),
                                    textCapitalization: TextCapitalization.sentences,
                                    autocorrect: false,
                                    validator: (String? value) =>
                                        (value?.trim() ?? '').length < 5 ? 'Put a valid review' : null,
                                    onEditingComplete: controller.descriptionFocus.unfocus,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Flexible(
                                      child: TextButton(
                                        onPressed: Get.back,
                                        child: const Text('CANCEL'),
                                      ),
                                    ),
                                    Flexible(
                                      child: Obx(
                                        () => ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppTheme.primaryColor,
                                            foregroundColor: Colors.white,
                                          ),
                                          onPressed: !controller.isValid
                                              ? null
                                              : () async {
                                                  final result = await controller.createReview();
                                                  if (result.isError) {
                                                    CustomSnackbar.showMessageError(message: result.error);
                                                  } else if (result.isSuccess) {
                                                    Get.back();
                                                    CustomSnackbar.showMessageSuccess(
                                                        title: 'Created Review',
                                                        message: 'Your review was created with successfull!');
                                                  }
                                                },
                                          child: controller.isLoading
                                              ? const CircularProgressIndicator()
                                              : const Text('CONFIRM'),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        isDismissible: false,
                        isScrollControlled: true,
                        enableDrag: false,
                      );

                      /// Resets all values of review
                      controller.rating = 0;
                      controller.reviewTitleText = '';
                      controller.reviewDescriptionText = '';
                    },
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text('ADD YOUR REVIEW',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                  ),
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 50))
        ],
      ),
    );
  }
}
