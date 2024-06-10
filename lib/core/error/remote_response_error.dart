class RemoteResponseError {
  int? code;
  String message;
  String? errorCode;

  RemoteResponseError({this.code, required this.message, this.errorCode});

  factory RemoteResponseError.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return RemoteResponseError(
        code: null,
        message: 'Response was null',
      );
    } else if (json.containsKey('code') && json.containsKey('msg')) {
      return RemoteResponseError(
        code: json['code'],
        message: json['msg'],
      );
    } else if (json.containsKey('error') &&
        json['error'] is Map<String, dynamic> &&
        json['error'].containsKey('code') &&
        json['error'].containsKey('message')) {
      return RemoteResponseError(
        code: null,
        message: json['error']['message'],
        errorCode: json['error']['code'],
      );
    } else {
      return RemoteResponseError(
        code: null,
        message: 'Unknown error format',
      );
    }
  }
}
