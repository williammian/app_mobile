class ValidacaoException implements Exception {
  final String message;

  const ValidacaoException([this.message = ""]);

  @override
  String toString() => message;

  String getMessage() {
    return message;
  }
}
