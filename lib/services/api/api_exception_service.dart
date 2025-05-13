import 'package:la_bonne_franquette_front/services/exception/api_exception.dart';

class ApiExceptionService {

  static ApiException throwError(int statusCode, String? body) {
    switch (statusCode) {
      case 400:
        return BadRequestException(body);
      case 401:
        return UnauthorizedException(body);
      case 403:
        return ForbiddenException(body);
      case 404:
        return NotFoundException(body);
      default:
          return ServerErrorException(statusCode, body);
    }
  }
}
