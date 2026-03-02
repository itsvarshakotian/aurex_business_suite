import 'package:dio/dio.dart';
import '../../core/services/dio_service.dart';
import '../../core/resources/url_resources.dart';
import '../models/user_model.dart';

class AuthRepository {

  final Dio _dio = DioService().dio;

  Future<UserModel> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        UrlResources.login,
        data: {
          "username": username,
          "password": password,
          "expiresInMins": 30,
        },
      );

      return UserModel.fromJson(response.data);

    } on DioException catch (_) {

      /// 🔥 Fallback Demo Login
      if (username == "admin" && password == "1234") {
        return UserModel(
          id: 1,
          username: "admin",
          token: "demo_token_123",
        );
      }

      throw Exception("Invalid credentials");
    }
  }
}