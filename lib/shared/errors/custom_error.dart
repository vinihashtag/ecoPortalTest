class CustomException implements Exception {
  Object? _exception;

  late final StackTrace _stackTrace;

  // This message is going to appear to the user as a toast.
  static String? _message;

  CustomException({String? message, Object? exception, StackTrace? stackTrace}) {
    _message = message;
    _exception = exception;
    _stackTrace = stackTrace ?? StackTrace.current;
  }

  static String get text => _message ?? 'Unexpected error, try again.';

  Type? get typeError => _exception?.runtimeType;

  @override
  String toString() => '$text\n$_stackTrace\n${_exception ?? ''}';
}
