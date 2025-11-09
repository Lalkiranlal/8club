import 'package:dio/dio.dart';
import 'package:test/constants/api_constants.dart';

class DioClient {
  final Dio _dio;
  DioClient([Dio? dio])
      : _dio = dio ?? Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));

  Dio get client => _dio;
}
