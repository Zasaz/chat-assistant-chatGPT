import '../exceptions/exceptions.dart';

class Failure {
  final String message;

  Failure({this.message = 'Something happened'});

  @override
  String toString() => message;
}

// Network
class NoInternetFailure extends Failure {
  @override
  // ignore: overridden_fields
  final String message = NoInternetException().message;

  NoInternetFailure();

  @override
  String toString() => message;
}

class PoorInternetFailure extends Failure {
  @override
  final String message = PoorInternetException().message;

  PoorInternetFailure();

  @override
  String toString() => message;
}

// Authentication
class SignInFailure extends Failure {
  @override
  final String message = SignInException().message;

  SignInFailure();

  @override
  String toString() => message;
}

class SignInCancelledFailure extends Failure {
  @override
  final String message = SignInCancelledException().message;

  SignInCancelledFailure();

  @override
  String toString() => message;
}

class SignInRequiredFailure extends Failure {
  @override
  final String message = SignInRequiredException().message;

  SignInRequiredFailure();

  @override
  String toString() => message;
}

class SignOutFailure extends Failure {
  @override
  final String message = SignOutException().message;

  SignOutFailure();

  @override
  String toString() => message;
}

// Unknown
class UnknownFailure extends Failure {
  @override
  final String message = UnknownException().message;

  UnknownFailure();

  @override
  String toString() => message;
}

// Cloud Backup

class CloudBackupFileNotFoundFailure extends Failure {
  @override
  final String message = CloudBackupFileNotFoundException().message;

  CloudBackupFileNotFoundFailure();

  @override
  String toString() => message;
}
