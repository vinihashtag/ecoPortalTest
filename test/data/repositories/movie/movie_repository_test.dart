import 'package:coolmovies/data/models/movie_model.dart';
import 'package:coolmovies/data/repositories/movie/movie_repository.dart';
import 'package:coolmovies/data/repositories/movie/movie_repository_interface.dart';
import 'package:coolmovies/shared/errors/custom_error.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/class_mocks.dart';
import '../../../mocks/fake_mocks.dart';
import '../../../mocks/json_mocks.dart';

void main() {
  late GraphQLClient client;
  late IMovieRepository movieRepository;

  setUp(() {
    registerFallbackValue(QueryOptionsFake());
    registerFallbackValue(MutationOptionsFake());
    client = MockGraphQLClient();
    movieRepository = MovieRepository(client);
  });

  group('[Gets all movies]', () {
    test('should returns all movies', () async {
      //Arrange
      QueryResult resultQuery = MockQueryResult();
      when(() => resultQuery.hasException).thenReturn(false);
      when(() => resultQuery.data).thenReturn(JsonMocks.getAllMovies);
      when(() => client.query(any())).thenAnswer((v) async => resultQuery);

      //Act
      final response = await movieRepository.getAllMovies();

      //Assert
      expect(response.isSuccess, true);
      expect(response.isError, false);
      expect((response.data as List<MovieModel>).isNotEmpty, true);
      verify(() => client.query(any())).called(1);
    });

    test('should returns a empty list when has invalid response', () async {
      //Arrange
      QueryResult resultQuery = MockQueryResult();
      when(() => resultQuery.hasException).thenReturn(false);
      when(() => resultQuery.data).thenReturn({});
      when(() => client.query(any())).thenAnswer((v) async => resultQuery);

      //Act
      final response = await movieRepository.getAllMovies();

      //Assert
      expect(response.isSuccess, true);
      expect((response.data as List<MovieModel>).isEmpty, true);
      verify(() => client.query(any())).called(1);
    });

    test('should returns a exception when has error in server side', () async {
      //Arrange
      QueryResult resultQuery = MockQueryResult();
      when(() => resultQuery.hasException).thenReturn(true);
      when(() => resultQuery.exception).thenReturn(OperationException());
      when(() => client.query(any())).thenAnswer((v) async => resultQuery);

      //Act
      final response = await movieRepository.getAllMovies();

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
      final response = await movieRepository.getAllMovies();

      //Assert
      expect(response.isSuccess, false);
      expect(response.isError, true);
      expect((response.error as CustomException).typeError == null, true);
      verify(() => client.query(any())).called(1);
    });
  });
}
