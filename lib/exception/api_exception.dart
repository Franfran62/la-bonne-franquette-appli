sealed class ApiException implements Exception {
  final int statusCode;
  final String? body;
  final String message;
  ApiException(this.statusCode, this.body, {this.message = "Une erreur est survenue"});
}

class ConnectionException extends ApiException {
  ConnectionException([String? body]) : super(503, body, message: "Impossible de se connetcer au serveur");
}

class BadRequestException extends ApiException { // 400
  BadRequestException([String? body]) : super(400, body);
}

class UnauthorizedException extends ApiException { // 401
  UnauthorizedException([String? body]) : super(401, body, message: "Vous n'êtes pas autorisé à faire ça");
}

class ForbiddenException extends ApiException { // 403
  ForbiddenException([String? body]) : super(403, body, message: "Vous avez été déconnecté");
}

class NotFoundException extends ApiException { // 404
  NotFoundException([String? body]) : super(404, body, message: "La ressource est introuvable");
}

class ServerErrorException extends ApiException { // 5xx
  ServerErrorException(super.code, super.body);
}