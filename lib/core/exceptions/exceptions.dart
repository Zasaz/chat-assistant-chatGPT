// Network
class NoInternetException implements Exception {
  final String message = "No internet connection";
  @override
  String toString() => message;
}

class PoorInternetException implements Exception {
  final String message = "Poor internet connection";
  @override
  String toString() => message;
}

// Authentication
class SignInException implements Exception {
  final String message = "Signing in failed";
  @override
  String toString() => message;
}

class SignInCancelledException implements Exception {
  final String message = "Signing in cancelled";
  @override
  String toString() => message;
}

class SignOutException implements Exception {
  final String message = "Signing out failed";
  @override
  String toString() => message;
}

class SignInRequiredException implements Exception {
  final String message = "Signing in required";
  @override
  String toString() => message;
}

// Unknown
class UnknownException implements Exception {
  final String message = "Something happened";
  @override
  String toString() => message;
}

// Cloud Backup
class CloudBackupFileNotFoundException implements Exception {
  final String message = "Back up file not found";
  @override
  String toString() => message;
}
