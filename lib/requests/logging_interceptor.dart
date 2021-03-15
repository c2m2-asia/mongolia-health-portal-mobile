import 'package:dio/dio.dart';

class LoggingInterceptor extends Interceptor {
  int _maxCharactersPerLine = 200;

  @override
  Future onRequest(RequestOptions options) {
    print("--> ${options.method} ${options.path}");
    print("Content type: ${options.contentType}");
    if (options.queryParameters != null) {
      print("queryParameters:");
      options.queryParameters.forEach((k, v) => print('$k: $v'));
    }
    print("<-- END HTTP");
    return super.onRequest(options);
  }

  @override
  Future onResponse(Response response) {
    print(
        "<-- ${response.statusCode} ${response.request.method} ${response.request.path}");
    String responseAsString = response.data.toString();
    if (responseAsString.length > _maxCharactersPerLine) {
      int iterations =
          (responseAsString.length / _maxCharactersPerLine).floor();
      for (int i = 0; i <= iterations; i++) {
        int endingIndex = i * _maxCharactersPerLine + _maxCharactersPerLine;
        if (endingIndex > responseAsString.length) {
          endingIndex = responseAsString.length;
        }
        print(
            responseAsString.substring(i * _maxCharactersPerLine, endingIndex));
      }
    } else {
      print(response.data);
    }
    print("<-- END HTTP");

    return super.onResponse(response);
  }

  @override
  Future onError(DioError dioError) {
    print(
        "<-- ${dioError.message} ${(dioError.response?.request != null ? (dioError.response.request.baseUrl + dioError.response.request.path) : 'URL')}");
    print(
        "${dioError.response != null ? dioError.response.data : 'Unknown Error'}");
    print("<-- End error");
    return super.onError(dioError );
  }
}
