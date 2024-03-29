import 'package:coolmovies/data/repositories/movie/movie_repository_interface.dart';
import 'package:coolmovies/shared/stores/connectivity_store.dart';
import 'package:get/get.dart';

import '../../data/models/movie_model.dart';
import '../../shared/enums/status_type_enum.dart';

class MovieController extends GetxController {
  final ConnectivityStore _connectivityStore;
  final IMovieRepository _movieRepository;

  MovieController(this._connectivityStore, this._movieRepository);

  // * Variables
  // * ----------------------------------------------------------------------------------------------------------------
  // * ----------------------------------------------------------------------------------------------------------------

  /// Controls list of movies
  final List<MovieModel> movies = [];

  // * Observables
  // * ----------------------------------------------------------------------------------------------------------------
  // * ----------------------------------------------------------------------------------------------------------------

  /// Controls status of page
  final Rx<StatusTypeEnum> _statusScreen = Rx<StatusTypeEnum>(StatusTypeEnum.idle);
  StatusTypeEnum get statusScreen => _statusScreen.value;

  // * Actions
  // * ----------------------------------------------------------------------------------------------------------------
  // * ----------------------------------------------------------------------------------------------------------------

  @override
  void onInit() {
    getMovies();
    super.onInit();
  }

  /// Returns a list of movies
  Future<void> getMovies() async {
    if (statusScreen.isLoading) return;

    _statusScreen.value = StatusTypeEnum.loading;

    await _connectivityStore.completer.future;

    if (!_connectivityStore.isConnected) {
      _statusScreen.value = StatusTypeEnum.noConnection;
      return;
    }

    final result = await _movieRepository.getAllMovies();

    if (result.isError) {
      _statusScreen.value = StatusTypeEnum.failure;
    } else {
      movies.clear();

      movies.addAll(result.data ?? []);

      _statusScreen.value = StatusTypeEnum.success;
    }
  }
}
