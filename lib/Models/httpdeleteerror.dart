class HttpDeleteException implements Exception{
  final String message;
  HttpDeleteException(this.message);
  @override
  String toString() {
    // TODO: implement toString
    return message;
  }
}