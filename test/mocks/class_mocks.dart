import 'dart:async';

import 'package:coolmovies/data/repositories/movie/movie_repository_interface.dart';
import 'package:coolmovies/data/repositories/review/review_repository_interface.dart';
import 'package:coolmovies/shared/stores/connectivity_store.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mocktail/mocktail.dart';

class MockConnectivityStore extends Mock implements ConnectivityStore {}

class MockMovieRepository extends Mock implements IMovieRepository {}

class MockReviewRepository extends Mock implements IReviewRepository {}

class MockGraphQLClient extends Mock implements GraphQLClient {}

class MockQueryResult extends Mock implements QueryResult {}

class MockCompleter extends Mock implements Completer {}
