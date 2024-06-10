import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'remote_exception.freezed.dart';

sealed class RemoteExcepetion {}

@freezed
class ServerException extends RemoteExcepetion with _$ServerException {
  const factory ServerException({
    required int? code,
    required String message,
  }) = _ServerException;
}
