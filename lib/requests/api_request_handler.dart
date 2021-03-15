import 'package:c2m2_mongolia/ui/strings.dart';
import 'package:dio/dio.dart';

import 'logging_interceptor.dart';

class APIRequestHandler {
  Dio createDio() {
    return Dio(BaseOptions(
      connectTimeout: 5000,
      receiveTimeout: 5000,
      baseUrl: Strings.API_BASE_URL,
    ));
  }

  Dio addInterceptors(Dio dio) {
    // dio.interceptors.add(LoggingInterceptor());
  }
}
