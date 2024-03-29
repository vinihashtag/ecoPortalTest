import 'package:coolmovies/data/models/movie_model.dart';
import 'package:coolmovies/data/models/response_model.dart';
import 'package:coolmovies/data/models/review_model.dart';
import 'package:coolmovies/data/repositories/review/review_repository_interface.dart';
import 'package:coolmovies/modules/movie_details/movie_details_controller.dart';
import 'package:coolmovies/shared/errors/custom_error.dart';
import 'package:coolmovies/shared/stores/connectivity_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/class_mocks.dart';
import '../../mocks/fake_mocks.dart';

void main() {
  late ConnectivityStore connectivityStore;
  late IReviewRepository reviewRepository;
  late MovieDetailsController movieDetailsController;

  final MovieModel mockMovie = MovieModel(
    id: 'movie.id',
    imgUrl: 'imgUrl',
    title: 'title',
    releaseDate: DateTime(2024),
    nodeId: 'nodeId',
  );
  final ReviewModel mockReview = ReviewModel(
    id: '123',
    title: 'reviewTitleText',
    body: 'reviewDescriptionText',
    movieId: 'movie.id',
    nodeId: '1234',
    rating: 4.0,
    userReviewerId: 'idUserMock',
  );

  setUp(() {
    registerFallbackValue(ReviewModelFake());
    connectivityStore = MockConnectivityStore();
    reviewRepository = MockReviewRepository();
    movieDetailsController = MovieDetailsController(mockMovie, connectivityStore, reviewRepository);
  });

  group('[Gets all reviews]', () {
    test('should returns all reviews of movie', () async {
      //Arrange
      when(() => connectivityStore.isConnected).thenReturn(true);
      when(() => reviewRepository.getReviewsByMovieId(any()))
          .thenAnswer((v) async => ResponseModel(data: [mockReview]));

      //Act
      await movieDetailsController.getAllReviewsByMovie();

      //Assert
      expect(movieDetailsController.statusScreen.isSuccess, true);
      expect(movieDetailsController.reviews.isNotEmpty, true);
      verify(() => reviewRepository.getReviewsByMovieId(any())).called(1);
    });

    test('should return status: no internet connection', () async {
      //Arrange
      when(() => connectivityStore.isConnected).thenReturn(false);

      //Act
      await movieDetailsController.getAllReviewsByMovie();

      //Assert
      expect(movieDetailsController.statusScreen.isNoConnection, true);
      verifyNever(() => reviewRepository.getReviewsByMovieId(any()));
    });

    test('should block a new request when is loading', () async {
      //Arrange
      when(() => connectivityStore.isConnected).thenReturn(true);
      when(() => reviewRepository.getReviewsByMovieId(any()))
          .thenAnswer((v) async => ResponseModel(data: [mockReview]));

      //Act
      await Future.wait([
        movieDetailsController.getAllReviewsByMovie(),
        movieDetailsController.getAllReviewsByMovie(),
      ]);

      //Assert
      expect(movieDetailsController.statusScreen.isSuccess, true);
      expect(movieDetailsController.reviews.isNotEmpty, true);
      verify(() => reviewRepository.getReviewsByMovieId(any())).called(1);
    });

    test('should returns a exception when has error in server side', () async {
      //Arrange
      when(() => connectivityStore.isConnected).thenReturn(true);
      when(() => reviewRepository.getReviewsByMovieId(any()))
          .thenAnswer((v) async => ResponseModel(error: CustomException()));

      //Act
      await movieDetailsController.getAllReviewsByMovie();

      //Assert
      expect(movieDetailsController.statusScreen.isFailure, true);
      expect(movieDetailsController.reviews.isEmpty, true);
      verify(() => reviewRepository.getReviewsByMovieId(any())).called(1);
    });
  });

  group('[Creates a review]', () {
    test('should create a new review', () async {
      //Arrange
      when(() => connectivityStore.isConnected).thenReturn(true);
      when(() => reviewRepository.saveReview(any())).thenAnswer((v) async => ResponseModel(data: mockReview));

      //Act
      final response = await movieDetailsController.createReview();

      //Assert
      expect(response.isSuccess, true);
      expect(movieDetailsController.isLoading, false);
      expect(movieDetailsController.reviews.isNotEmpty, true);
      verify(() => reviewRepository.saveReview(any())).called(1);
    });

    test('should returns a error message when response is null', () async {
      //Arrange
      when(() => connectivityStore.isConnected).thenReturn(true);
      when(() => reviewRepository.saveReview(any())).thenAnswer((v) async => ResponseModel());

      //Act
      final response = await movieDetailsController.createReview();

      //Assert
      expect(response.error is String, true);
      expect((response.error as String).contains('validation'), true);
      expect(movieDetailsController.isLoading, false);
      expect(movieDetailsController.reviews.isEmpty, true);
      verify(() => reviewRepository.saveReview(any())).called(1);
    });

    test('should returns a error message when have not connection with internet', () async {
      //Arrange
      when(() => connectivityStore.isConnected).thenReturn(false);

      //Act
      final response = await movieDetailsController.createReview();

      //Assert
      expect(response.isError, true);
      verifyNever(() => reviewRepository.saveReview(any()));
    });

    test('should block a new request when is loading', () async {
      //Arrange
      when(() => connectivityStore.isConnected).thenReturn(true);
      when(() => reviewRepository.saveReview(any())).thenAnswer((v) async => ResponseModel(data: mockReview));

      //Act
      final response = await Future.wait([
        movieDetailsController.createReview(),
        movieDetailsController.createReview(),
      ]);

      //Assert
      expect(response.first.isSuccess, true);
      expect(response.last.data == null, true);
      expect(response.last.error == null, true);
      verify(() => reviewRepository.saveReview(any())).called(1);
    });

    test('should returns a exception when has error in server side', () async {
      //Arrange
      when(() => connectivityStore.isConnected).thenReturn(true);
      when(() => reviewRepository.saveReview(any())).thenAnswer((v) async => ResponseModel(error: CustomException()));

      //Act
      final response = await movieDetailsController.createReview();

      //Assert
      expect(response.isError, true);
      expect(movieDetailsController.reviews.isEmpty, true);
      verify(() => reviewRepository.saveReview(any())).called(1);
    });
  });

  group('[Deletes a review]', () {
    test('should delete a new review', () async {
      //Arrange
      when(() => connectivityStore.isConnected).thenReturn(true);
      when(() => reviewRepository.deleteReview(any())).thenAnswer((v) async => ResponseModel(data: true));

      //Act
      movieDetailsController.reviews.add(mockReview);
      await movieDetailsController.deleteReview(mockReview);

      //Assert
      expect(movieDetailsController.isLoading, false);
      expect(movieDetailsController.reviews.isEmpty, true);
      verify(() => reviewRepository.deleteReview(any())).called(1);
    });

    test('should returns a error message when have not connection with internet', () async {
      //Arrange
      when(() => connectivityStore.isConnected).thenReturn(false);

      //Act
      final response = await movieDetailsController.deleteReview(mockReview);

      //Assert
      expect(response.isError, true);
      verifyNever(() => reviewRepository.deleteReview(any()));
    });

    test('should block a new request when is loading', () async {
      //Arrange
      when(() => connectivityStore.isConnected).thenReturn(true);
      when(() => reviewRepository.deleteReview(any())).thenAnswer((v) async => ResponseModel(data: true));

      //Act
      final response = await Future.wait([
        movieDetailsController.deleteReview(mockReview),
        movieDetailsController.deleteReview(mockReview),
      ]);

      //Assert
      expect(response.first.isSuccess, true);
      expect(response.last.data == null, true);
      expect(response.last.error == null, true);
      verify(() => reviewRepository.deleteReview(any())).called(1);
    });

    test('should returns a exception when has error in server side', () async {
      //Arrange
      when(() => connectivityStore.isConnected).thenReturn(true);
      when(() => reviewRepository.deleteReview(any())).thenAnswer((v) async => ResponseModel(error: CustomException()));

      //Act
      final response = await movieDetailsController.deleteReview(mockReview);

      //Assert
      expect(response.isError, true);
      verify(() => reviewRepository.deleteReview(any())).called(1);
    });
  });
}
