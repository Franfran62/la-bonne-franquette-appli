class JsonException implements Exception {
  final String message;
  final String body;

  JsonException(this.body, [this.message = "Une erreur est survenue lors du traitement de la réponse"]);
}