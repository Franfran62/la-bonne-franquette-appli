sealed class RequestException implements Exception {
  final int statusCode;
  final String? body;
  final String message;
  RequestException(this.statusCode, this.body,
      {this.message = "Une erreur est survenue"});
}

class ConnectionException extends RequestException {
  ConnectionException([String? body])
      : super(503, body,
            message:
                "Une erreur est survenue lors de la connection au serveur");
}

class BadRequestException extends RequestException {
  // 400
  BadRequestException([String? body]) : super(400, body);
}

class UnauthorizedException extends RequestException {
  // 401
  UnauthorizedException([String? body])
      : super(401, body, message: "Vous n'êtes pas autorisé à faire ça");
}

class ForbiddenException extends RequestException {
  // 403
  ForbiddenException([String? body])
      : super(403, body, message: "Vous avez été déconnecté");
}

class NotFoundException extends RequestException {
  // 404
  NotFoundException([String? body])
      : super(404, body, message: "La ressource est introuvable");
}

class ServerErrorException extends RequestException {
  // 5xx
  ServerErrorException(super.code, super.body);
}
