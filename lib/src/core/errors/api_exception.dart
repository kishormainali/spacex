sealed class ApiException {
  const ApiException();
}

class ServerException extends ApiException {
  const ServerException({this.message = 'Something went wrong'});
  final String message;
}

class NetworkException extends ApiException {
  const NetworkException();
}
