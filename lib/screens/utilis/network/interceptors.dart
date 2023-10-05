import 'package:dio/dio.dart';

import '../storage.dart';

enum HeaderContentType { formType, jsonType }

class HeaderInterceptor extends Interceptor {
  final bool hasToken;
  final HeaderContentType contentType;
  final Dio dio;

  HeaderInterceptor({
    required this.hasToken,
    this.contentType = HeaderContentType.jsonType,
    required this.dio,
  });

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if (hasToken) {
      // print(await UserTokenManager.getAccessToken());
      var token = "Bearer ${await UserTokenManager.getAccessToken()}";

      options.headers["Authorization"] = token;
    }
    options.headers["Content-Type"] = contentType == HeaderContentType.jsonType
        ? "application/json"
        : "multipart/form-data";

    return super.onRequest(options, handler);
  }
}
