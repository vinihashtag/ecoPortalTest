enum StatusTypeEnum {
  idle,
  loading,
  empty,
  failure,
  noConnection,
  validating,
  success;

  bool get isInitial => this == StatusTypeEnum.idle;
  bool get isLoading => this == StatusTypeEnum.loading;
  bool get isEmpty => this == StatusTypeEnum.empty;
  bool get isFailure => this == StatusTypeEnum.failure;
  bool get isNoConnection => this == StatusTypeEnum.noConnection;
  bool get isValidating => this == StatusTypeEnum.validating;
  bool get isSuccess => this == StatusTypeEnum.success;
}
