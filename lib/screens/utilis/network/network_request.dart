import 'package:dio/dio.dart';

import '../../auth/route/routes.dart';
import '../../auth/sign_in/model/user.dart';
import '../config/app_configs.dart';
import '../config/app_startup.dart';
import '../messenger.dart';
import '../navigation/navigation_service.dart';
import '../storage.dart';

bool _isRefreshing = false;

class HttpService {
  Dio? _dio;
  final String baseUrl;
  final bool hasAuthorization;
  final bool isFormType;

  HttpService(
      {required this.baseUrl,
      this.hasAuthorization = false,
      this.isFormType = false}) {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: 30000,
      receiveTimeout: 25000,
    ));
    _interceptorsInit();
  }
  static const int timeoutDuration = 1;

  Future<Response> getRequest(
    urlEndPoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    Response response;

    response = await _dio!
        .get(urlEndPoint, queryParameters: queryParameters)
        .timeout(const Duration(minutes: timeoutDuration));
    return response;
  }

  Future<Response> post(
    urlEndpoint, {
    data,
    Map<String, dynamic>? queryParameters,
  }) async {
    Response response;

    response = await _dio!
        .post(urlEndpoint, data: data, queryParameters: queryParameters)
        .timeout(const Duration(minutes: timeoutDuration));
    return response;
  }

  Future<Response> put(urlEndpoint,
      {data, Map<String, dynamic>? queryParameters}) async {
    Response response;

    response = await _dio!
        .put(urlEndpoint, data: data, queryParameters: queryParameters)
        .timeout(const Duration(minutes: timeoutDuration));

    return response;
  }

  Future<Response> delete(urlEndpoint,
      {data, Map<String, dynamic>? queryParameters}) async {
    Response response;

    response = await _dio!
        .delete(urlEndpoint, data: data, queryParameters: queryParameters)
        .timeout(const Duration(minutes: timeoutDuration));

    return response;
  }

  Future<Response> patch(urlEndpoint,
      {data, Map<String, dynamic>? queryParameters}) async {
    Response response;

    response = await _dio!
        .patch(urlEndpoint, data: data, queryParameters: queryParameters)
        .timeout(const Duration(minutes: timeoutDuration));

    return response;
  }

  _interceptorsInit() {
    _dio!.interceptors.addAll([
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (hasAuthorization) {
            var token = "Bearer ${await UserTokenManager.getAccessToken()}";

            options.headers["Authorization"] = token;
          }

          options.headers["Content-Type"] =
              !isFormType ? "application/json" : "multipart/form-data";

          return handler.next(options);
        },
        onError: (DioError error, handler) async {
          if (error.response?.statusCode == 403) {
            //clear();
          }

          return handler.next(error);
        },
      ),
    ]);
  }
}

clear() {
  Future.delayed(const Duration(seconds: 1), () {
    //getIt<HomeCubit>().cancelLocationTimer();
    NotificationMessage.showError(
        getIt<NavigationService>().navigatorKey.currentContext!,
        message: "Session expired, kindly login again to continue");
    UserTokenManager.deleteAccessToken();
    UserTokenManager.deleteRefreshToken();
    if (getIt.isRegistered<User>()) {
      getIt.unregister<User>();
    }
    LocalStorageUtils.delete(AppConstants.userObject);

    getIt<NavigationService>().clearAllTo(routeName: AuthRoutes.signIn);
  });
}

extension ResponseExt on Response {
  bool get isSuccessful => statusCode! >= 200 && statusCode! < 300;
  get body => data;
}

String errorDefaultMessage = "An Error Occurred";
// Error Handler Function
String networkErrorHandler(DioError error,
    {Function(DioError e)? onResponseError}) {
  switch (error.type) {
    case DioErrorType.response:
      if (onResponseError == null && error.response != null) {
        if (error.response?.statusCode == 500) {
          return errorDefaultMessage;
        }
        if (error.response?.data is Map) {
          return error.response?.data['message'];
        }
        return error.response?.data;
      }
      return onResponseError!(error);
    case DioErrorType.connectTimeout:
      return "Kindly Try Again";
    case DioErrorType.sendTimeout:
      return "Kindly Try Again";
    case DioErrorType.receiveTimeout:
      return "Kindly Try Again";
    case DioErrorType.cancel:
      return "Request Cancelled";
    case DioErrorType.other:
      return "Kindly Try Again";
    default:
      return errorDefaultMessage;
  }
}
