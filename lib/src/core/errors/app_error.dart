sealed class AppError {
  const AppError();

  @override
  String toString() {
    return switch (this) {
      ServerError(message: final message) => message,
      NetworkError() => 'Network Error',
    };
  }
}

class ServerError extends AppError {
  const ServerError({this.message = 'Something went wrong'});
  final String message;
}

class NetworkError extends AppError {
  const NetworkError();
}
