import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'cache_exception.freezed.dart';

sealed class CacheException {}

class NoValuesFoundedOnCacheException extends CacheException {}

@freezed
class DatabaseException extends CacheException with _$DatabaseException {
  const factory DatabaseException({
    required String message,
  }) = _DatabaseException;
}
