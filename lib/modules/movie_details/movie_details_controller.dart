import 'package:coolmovies/data/models/response_model.dart';
import 'package:coolmovies/data/repositories/review/review_repository_interface.dart';
import 'package:coolmovies/shared/errors/no_connection_error.dart';
import 'package:coolmovies/shared/stores/connectivity_store.dart';
import 'package:coolmovies/shared/utils/custom_logger.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/movie_model.dart';
import '../../data/models/review_model.dart';
import '../../shared/enums/status_type_enum.dart';

class MovieDetailsController extends GetxController {
  final MovieModel movie;
  final ConnectivityStore _connectivityStore;
  final IReviewRepository _reviewRepository;

  MovieDetailsController(this.movie, this._connectivityStore, this._reviewRepository);

  // * Controlls
  // * ----------------------------------------------------------------------------------------------------------------
  // * ----------------------------------------------------------------------------------------------------------------

  /// Controls scroll of page
  final ScrollController scrollController = ScrollController();
  final FocusNode titleFocus = FocusNode();
  final FocusNode descriptionFocus = FocusNode();

  // * Observables
  // * ----------------------------------------------------------------------------------------------------------------
  // * ----------------------------------------------------------------------------------------------------------------

  /// Controls status of page
  final Rx<StatusTypeEnum> _statusScreen = Rx<StatusTypeEnum>(StatusTypeEnum.idle);
  StatusTypeEnum get statusScreen => _statusScreen.value;

  /// Controls a list of reviews
  final RxList<ReviewModel> reviews = RxList();

  /// Controls visibility title
  final Rx<bool> _isVisibleTitle = Rx<bool>(false);
  bool get isVisibleTitle => _isVisibleTitle.value;

  /// Controls rating of new review
  final Rx<double> _rating = Rx<double>(0);
  double get rating => _rating.value;
  set rating(double value) => _rating.value = value;

  /// Controls text title of new review
  final Rx<String> _reviewTitleText = Rx<String>('');
  String get reviewTitleText => _reviewTitleText.value;
  set reviewTitleText(String value) => _reviewTitleText.value = value;

  /// Controls description of new review
  final Rx<String> _reviewDescriptionText = Rx<String>('');
  String get reviewDescriptionText => _reviewDescriptionText.value;
  set reviewDescriptionText(String value) => _reviewDescriptionText.value = value;

  /// Controls loading on create and delete review
  final Rx<bool> _isLoading = Rx<bool>(false);
  bool get isLoading => _isLoading.value;

  // * Getters
  // * ----------------------------------------------------------------------------------------------------------------
  // * ----------------------------------------------------------------------------------------------------------------

  /// Validation to allow create a review
  bool get isValid => reviewTitleText.trim().length >= 3 && reviewDescriptionText.trim().length >= 5 && rating > 0;

  /// User id faker to create a review
  String get idUserMock => 'ffd3a780-26e8-450b-856d-c45dc43c1315';

  // * Actions
  // * ----------------------------------------------------------------------------------------------------------------
  // * ----------------------------------------------------------------------------------------------------------------

  @override
  void onInit() {
    scrollController.addListener(_listenToScrollChange);
    getAllReviewsByMovie();
    super.onInit();
  }

  /// Gets all reviews of movie
  Future<void> getAllReviewsByMovie() async {
    if (!_connectivityStore.isConnected) {
      _statusScreen.value = StatusTypeEnum.noConnection;
      return;
    }

    if (statusScreen.isLoading) return;

    _statusScreen.value = StatusTypeEnum.loading;

    final response = await _reviewRepository.getReviewsByMovieId(movie.id);

    if (response.isError) {
      _statusScreen.value = StatusTypeEnum.failure;
    } else {
      reviews.clear();
      reviews.addAll(response.data ?? []);
      _statusScreen.value = StatusTypeEnum.success;
    }
  }

  /// Creates a new review
  Future<ResponseModel> createReview() async {
    try {
      if (!_connectivityStore.isConnected) {
        return ResponseModel(error: NoConnectionError.text);
      }

      if (isLoading) return ResponseModel();

      _isLoading.value = true;

      final response = await _reviewRepository.saveReview(
        ReviewModel(
          id: '',
          title: reviewTitleText,
          body: reviewDescriptionText,
          movieId: movie.id,
          nodeId: '',
          rating: rating,
          userReviewerId: idUserMock,
        ),
      );

      if (response.isError) {
        return ResponseModel(error: response.error);
      } else {
        if (response.data != null) {
          reviews.add(response.data!);
          return ResponseModel(data: true);
        } else {
          return ResponseModel(error: 'Error on validation on save review, try again!');
        }
      }
    } catch (e, s) {
      LoggerApp.error('Error on save review', e, s);
      return ResponseModel(error: 'Error on save review, try again!');
    } finally {
      _isLoading.value = false;
    }
  }

  /// Deletes a review
  Future<ResponseModel> deleteReview(ReviewModel review) async {
    try {
      if (!_connectivityStore.isConnected) {
        return ResponseModel(error: NoConnectionError.text);
      }

      if (isLoading) return ResponseModel();

      _isLoading.value = true;

      final response = await _reviewRepository.deleteReview(review.id);

      if (response.isError) {
        return ResponseModel(error: response.error);
      } else {
        reviews.remove(review);

        return ResponseModel(data: true);
      }
    } catch (e, s) {
      LoggerApp.error('Error on delete review', e, s);
      return ResponseModel(error: 'Error on delete review, try again!');
    } finally {
      _isLoading.value = false;
    }
  }

  /// Listener of scroll page to hide or show title
  void _listenToScrollChange() {
    if (scrollController.offset >= 170) {
      _isVisibleTitle.value = true;
    } else {
      _isVisibleTitle.value = false;
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    titleFocus.dispose();
    descriptionFocus.dispose();
    super.dispose();
  }
}
