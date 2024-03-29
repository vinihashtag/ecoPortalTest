import 'package:coolmovies/shared/errors/custom_error.dart';

class NoConnectionError extends CustomException {
  NoConnectionError();

  static String get text => 'No connection internet, verify your network!';
}
