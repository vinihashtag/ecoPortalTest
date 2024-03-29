import 'package:coolmovies/data/models/response_model.dart';
import 'package:coolmovies/data/repositories/review/review_repository_interface.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../shared/errors/custom_error.dart';
import '../../../shared/utils/custom_logger.dart';
import '../../models/review_model.dart';

class ReviewRepository implements IReviewRepository {
  final GraphQLClient _client;

  ReviewRepository(this._client);

  @override
  Future<ResponseModel<List<ReviewModel>, CustomException>> getReviewsByMovieId(String movieId) async {
    try {
      final QueryResult result = await _client.query(
        QueryOptions(
          document: gql('''
            query GetMovieReviews(\$movieId: UUID!) {
              allMovieReviews(
                orderBy: PRIMARY_KEY_ASC
                condition: {movieId: \$movieId}) {
                nodes {
                  id
                  rating
                  title
                  body
                  userReviewerId
                }
              }
            }
          '''),
          variables: {'movieId': movieId},
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );

      if (result.hasException) {
        LoggerApp.error('Error on GraphQL: ${result.exception}');
        return ResponseModel(
          error: CustomException(
            message: 'Error on get all reviews by movie id',
            exception: result.exception,
          ),
        );
      }

      if (result.data != null) {
        final List listMovies = result.data?['allMovieReviews']?['nodes'] ?? [];
        return ResponseModel(data: listMovies.map((e) => ReviewModel.fromMap(e)).toList());
      } else {
        return ResponseModel(error: CustomException(message: 'Invalid response of reviews'));
      }
    } catch (e, s) {
      return ResponseModel(
        error: CustomException(
          message: 'Unexpected error on get all reviews',
          exception: e,
          stackTrace: s,
        ),
      );
    }
  }

  @override
  Future<ResponseModel<ReviewModel, CustomException>> saveReview(review) async {
    try {
      const String mutation = '''
        mutation CreateReview(\$title: String!, \$movieId: UUID!, \$userReviewerId: UUID!, \$body: String!, \$rating: Int!) {
          createMovieReview(input: {movieReview: {title: \$title, movieId: \$movieId, userReviewerId: \$userReviewerId, body: \$body, rating: \$rating}}) {
            movieReview {
              id
              title
              body
              movieId
              nodeId
              rating
              userReviewerId
            }
          }
        }
      ''';

      final MutationOptions options = MutationOptions(
        document: gql(mutation),
        variables: {
          'title': review.title.trim(),
          'movieId': review.movieId,
          'userReviewerId': review.userReviewerId,
          'body': review.body.trim(),
          'rating': review.rating.toInt(),
        },
      );

      final QueryResult result = await _client.mutate(options);

      if (result.hasException) {
        LoggerApp.error('Error on GraphQL: ${result.exception}');
        return ResponseModel(
          error: CustomException(
            message: 'Error on save review',
            exception: result.exception,
          ),
        );
      }

      if (result.data != null) {
        return ResponseModel(data: ReviewModel.fromMap(result.data!['createMovieReview']!['movieReview']));
      } else {
        return ResponseModel(error: CustomException(message: 'Invalid response on save review'));
      }
    } catch (e, s) {
      return ResponseModel(
        error: CustomException(
          message: 'Unexpected error on save review',
          exception: e,
          stackTrace: s,
        ),
      );
    }
  }

  @override
  Future<ResponseModel<bool, CustomException>> deleteReview(String id) async {
    try {
      const String mutation = '''
              mutation DeleteMovieReview(\$id: UUID!) {
                deleteMovieReviewById(input: {id: \$id}){
                  deletedMovieReviewId
                }
              }
            ''';

      final MutationOptions options = MutationOptions(
        document: gql(mutation),
        variables: {'id': id},
      );

      final QueryResult result = await _client.mutate(options);

      if (result.hasException) {
        LoggerApp.error('Error on GraphQL: ${result.exception}');
        return ResponseModel(
          error: CustomException(
            message: 'Error on delete review',
            exception: result.exception,
          ),
        );
      }

      if (result.data != null) {
        LoggerApp.success('response: ${result.data}');
        return ResponseModel(data: true);
      } else {
        return ResponseModel(error: CustomException(message: 'Invalid response on delete review'));
      }
    } catch (e, s) {
      return ResponseModel(
        error: CustomException(
          message: 'Unexpected error on delete review',
          exception: e,
          stackTrace: s,
        ),
      );
    }
  }
}
