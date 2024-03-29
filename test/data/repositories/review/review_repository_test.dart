import 'package:coolmovies/data/models/review_model.dart';
import 'package:coolmovies/data/repositories/review/review_repository.dart';
import 'package:coolmovies/data/repositories/review/review_repository_interface.dart';
import 'package:coolmovies/shared/errors/custom_error.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/class_mocks.dart';
import '../../../mocks/fake_mocks.dart';
import '../../../mocks/json_mocks.dart';

void main() {
  late GraphQLClient client;
  late IReviewRepository reviewRepository;

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
    registerFallbackValue(QueryOptionsFake());
    registerFallbackValue(MutationOptionsFake());
    client = MockGraphQLClient();
    reviewRepository = ReviewRepository(client);
  });

  group('[Gets all reviews by Id]', () {
    test('should returns all reviews of movie', () async {
      //Arrange
      QueryResult resultQuery = MockQueryResult();
      when(() => resultQuery.hasException).thenReturn(false);
      when(() => resultQuery.data).thenReturn(JsonMocks.getAllReviews);
      when(() => client.query(any())).thenAnswer((v) async => resultQuery);

      //Act
      final response = await reviewRepository.getReviewsByMovieId('mockMovie.id');

      //Assert
      expect(response.isSuccess, true);
      expect(response.isError, false);
      expect((response.data as List<ReviewModel>).isNotEmpty, true);
      verify(() => client.query(any())).called(1);
    });

    test('should returns a empty list when has invalid response', () async {
      //Arrange
      QueryResult resultQuery = MockQueryResult();
      when(() => resultQuery.hasException).thenReturn(false);
      when(() => resultQuery.data).thenReturn({});
      when(() => client.query(any())).thenAnswer((v) async => resultQuery);

      //Act
      final response = await reviewRepository.getReviewsByMovieId('mockMovie.id');

      //Assert
      expect(response.isSuccess, true);
      expect((response.data as List<ReviewModel>).isEmpty, true);
      verify(() => client.query(any())).called(1);
    });

    test('should returns a exception when has error in server side', () async {
      //Arrange
      QueryResult resultQuery = MockQueryResult();
      when(() => resultQuery.hasException).thenReturn(true);
      when(() => resultQuery.exception).thenReturn(OperationException());
      when(() => client.query(any())).thenAnswer((v) async => resultQuery);

      //Act
      final response = await reviewRepository.getReviewsByMovieId('mockMovie.id');

      //Assert
      expect(response.isSuccess, false);
      expect(response.isError, true);
      expect((response.error as CustomException).typeError == OperationException, true);
      verify(() => client.query(any())).called(1);
    });

    test('should returns a exception when resposne is null', () async {
      //Arrange
      QueryResult resultQuery = MockQueryResult();
      when(() => resultQuery.hasException).thenReturn(false);
      when(() => resultQuery.data).thenReturn(null);
      when(() => client.query(any())).thenAnswer((v) async => resultQuery);

      //Act
      final response = await reviewRepository.getReviewsByMovieId('mockMovie.id');

      //Assert
      expect(response.isSuccess, false);
      expect(response.isError, true);
      expect((response.error as CustomException).typeError == null, true);
      verify(() => client.query(any())).called(1);
    });
  });

  group('[Creates a review]', () {
    test('should create a new reviews', () async {
      //Arrange
      QueryResult resultQuery = MockQueryResult();
      when(() => resultQuery.hasException).thenReturn(false);
      when(() => resultQuery.data).thenReturn(JsonMocks.createdReview);
      when(() => client.mutate(any())).thenAnswer((v) async => resultQuery);

      //Act
      final response = await reviewRepository.saveReview(mockReview);

      //Assert
      expect(response.isSuccess, true);
      expect(response.isError, false);
      verify(() => client.mutate(any())).called(1);
    });

    test('should returns a empty when has invalid response', () async {
      //Arrange
      QueryResult resultQuery = MockQueryResult();
      when(() => resultQuery.hasException).thenReturn(false);
      when(() => resultQuery.data).thenReturn(null);
      when(() => client.mutate(any())).thenAnswer((v) async => resultQuery);

      //Act
      final response = await reviewRepository.saveReview(mockReview);

      //Assert
      expect(response.isSuccess, false);
      expect(response.isError, true);
      expect((response.error as CustomException).typeError == null, true);
      verify(() => client.mutate(any())).called(1);
    });

    test('should returns a exception when has error in server side', () async {
      //Arrange
      QueryResult resultQuery = MockQueryResult();
      when(() => resultQuery.hasException).thenReturn(true);
      when(() => resultQuery.exception).thenReturn(OperationException());
      when(() => client.mutate(any())).thenAnswer((v) async => resultQuery);

      //Act
      final response = await reviewRepository.saveReview(mockReview);

      //Assert
      expect(response.isSuccess, false);
      expect(response.isError, true);
      expect((response.error as CustomException).typeError == OperationException, true);
      verify(() => client.mutate(any())).called(1);
    });
  });

  group('[Deletes a review]', () {
    test('should delete a review', () async {
      //Arrange
      QueryResult resultQuery = MockQueryResult();
      when(() => resultQuery.hasException).thenReturn(false);
      when(() => resultQuery.data).thenReturn({});
      when(() => client.mutate(any())).thenAnswer((v) async => resultQuery);

      //Act
      final response = await reviewRepository.deleteReview(mockReview.id);

      //Assert
      expect(response.isSuccess, true);
      expect(response.isError, false);
      verify(() => client.mutate(any())).called(1);
    });

    test('should returns a empty when has invalid response', () async {
      //Arrange
      QueryResult resultQuery = MockQueryResult();
      when(() => resultQuery.hasException).thenReturn(false);
      when(() => resultQuery.data).thenReturn(null);
      when(() => client.mutate(any())).thenAnswer((v) async => resultQuery);

      //Act
      final response = await reviewRepository.deleteReview(mockReview.id);

      //Assert
      expect(response.isSuccess, false);
      expect(response.isError, true);
      expect((response.error as CustomException).typeError == null, true);
      verify(() => client.mutate(any())).called(1);
    });

    test('should returns a exception when has error in server side', () async {
      //Arrange
      QueryResult resultQuery = MockQueryResult();
      when(() => resultQuery.hasException).thenReturn(true);
      when(() => resultQuery.exception).thenReturn(OperationException());
      when(() => client.mutate(any())).thenAnswer((v) async => resultQuery);

      //Act
      final response = await reviewRepository.deleteReview(mockReview.id);

      //Assert
      expect(response.isSuccess, false);
      expect(response.isError, true);
      expect((response.error as CustomException).typeError == OperationException, true);
      verify(() => client.mutate(any())).called(1);
    });
  });
}
