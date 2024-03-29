import 'package:coolmovies/data/models/movie_model.dart';
import 'package:coolmovies/data/models/response_model.dart';
import 'package:coolmovies/data/repositories/movie/movie_repository_interface.dart';
import 'package:coolmovies/modules/movie/movie_controller.dart';
import 'package:coolmovies/shared/errors/custom_error.dart';
import 'package:coolmovies/shared/stores/connectivity_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/class_mocks.dart';

void main() {
  late ConnectivityStore connectivityStore;
  late IMovieRepository movieRepository;
  late MovieController movieController;

  final MovieModel mockMovie = MovieModel(
    id: 'movie.id',
    imgUrl: 'imgUrl',
    title: 'title',
    releaseDate: DateTime(2024),
    nodeId: 'nodeId',
  );

  setUp(() {
    connectivityStore = MockConnectivityStore();
    movieRepository = MockMovieRepository();
    movieController = MovieController(connectivityStore, movieRepository);
  });

  group('[Gets all movies]', () {
    test('should returns all movies', () async {
      //Arrange
      final completer = MockCompleter();
      when(() => completer.future).thenAnswer((v) => Future.value());
      when(() => connectivityStore.completer).thenReturn(completer);
      when(() => connectivityStore.isConnected).thenReturn(true);
      when(() => movieRepository.getAllMovies()).thenAnswer((v) async => ResponseModel(data: [mockMovie]));

      //Act
      await movieController.getMovies();

      //Assert
      expect(movieController.statusScreen.isSuccess, true);
      expect(movieController.movies.isNotEmpty, true);
      verify(() => movieRepository.getAllMovies()).called(1);
    });

    test('should block a new request when is loading', () async {
      //Arrange
      final completer = MockCompleter();
      when(() => completer.future).thenAnswer((v) => Future.value());
      when(() => connectivityStore.completer).thenReturn(completer);
      when(() => connectivityStore.isConnected).thenReturn(true);
      when(() => movieRepository.getAllMovies()).thenAnswer((v) async => ResponseModel(data: [mockMovie]));

      //Act
      await Future.wait([
        movieController.getMovies(),
        movieController.getMovies(),
      ]);

      //Assert
      expect(movieController.statusScreen.isSuccess, true);
      expect(movieController.movies.length, 1);
      verify(() => movieRepository.getAllMovies()).called(1);
    });

    test('should return status: no internet connection', () async {
      //Arrange
      final completer = MockCompleter();
      when(() => completer.future).thenAnswer((v) => Future.value());
      when(() => connectivityStore.completer).thenReturn(completer);
      when(() => connectivityStore.isConnected).thenReturn(false);

      //Act
      await movieController.getMovies();

      //Assert
      expect(movieController.statusScreen.isNoConnection, true);
      verifyNever(() => movieRepository.getAllMovies());
    });

    test('should returns a exception when has error in server side', () async {
      //Arrange
      final completer = MockCompleter();
      when(() => completer.future).thenAnswer((v) => Future.value());
      when(() => connectivityStore.completer).thenReturn(completer);
      when(() => connectivityStore.isConnected).thenReturn(true);
      when(() => movieRepository.getAllMovies()).thenAnswer((v) async => ResponseModel(error: CustomException()));

      //Act
      await movieController.getMovies();

      //Assert
      expect(movieController.statusScreen.isFailure, true);
      expect(movieController.movies.isEmpty, true);
      verify(() => movieRepository.getAllMovies()).called(1);
    });
  });
}
