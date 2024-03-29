import 'package:coolmovies/data/models/response_model.dart';

import '../../../shared/errors/custom_error.dart';
import '../../models/review_model.dart';

abstract class IReviewRepository {
  Future<ResponseModel<List<ReviewModel>, CustomException>> getReviewsByMovieId(String id);
  Future<ResponseModel<ReviewModel, CustomException>> saveReview(ReviewModel review);
  Future<ResponseModel<bool, CustomException>> deleteReview(String id);
}
