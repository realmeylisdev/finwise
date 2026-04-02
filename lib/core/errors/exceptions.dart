class DatabaseException implements Exception {
  const DatabaseException({required this.message});

  final String message;

  @override
  String toString() => 'DatabaseException: $message';
}

class CacheException implements Exception {
  const CacheException({required this.message});

  final String message;

  @override
  String toString() => 'CacheException: $message';
}
