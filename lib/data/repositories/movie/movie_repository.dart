import 'package:coolmovies/data/models/response_model.dart';
import 'package:coolmovies/data/repositories/movie/movie_repository_interface.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../shared/errors/custom_error.dart';
import '../../../shared/utils/custom_logger.dart';
import '../../models/movie_model.dart';

class MovieRepository implements IMovieRepository {
  final GraphQLClient _client;

  MovieRepository(this._client);

  @override
  Future<ResponseModel<List<MovieModel>, CustomException>> getAllMovies() async {
    try {
      final QueryResult result = await _client.query(
        QueryOptions(
          document: gql(r"""
          query AllMovies {
            allMovies {
              edges {
                node {
                  id
                  imgUrl
                  title
                  nodeId
                  releaseDate
                }
              }
            }
          }
        """),
        ),
      );

      if (result.hasException) {
        LoggerApp.error('Error on GraphQL: ${result.exception}');

        return ResponseModel(
          error: CustomException(
            message: 'Error on get all movies',
            exception: result.exception,
          ),
        );
      }

      if (result.data != null) {
        final List listMovies = result.data?['allMovies']?['edges'] ?? [];
        return ResponseModel(data: listMovies.map((e) => MovieModel.fromMap(e['node'])).toList());
      } else {
        return ResponseModel(error: CustomException(message: 'Invalid response of movies'));
      }
    } catch (e, s) {
      return ResponseModel(
        error: CustomException(
          message: 'Unexpected error on get all movies',
          exception: e,
          stackTrace: s,
        ),
      );
    }
  }
}
