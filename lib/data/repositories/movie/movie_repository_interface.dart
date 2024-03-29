import '../../../shared/errors/custom_error.dart';
import '../../models/movie_model.dart';
import '../../models/response_model.dart';

abstract class IMovieRepository {
  Future<ResponseModel<List<MovieModel>, CustomException>> getAllMovies();
}
