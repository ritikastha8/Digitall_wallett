class ApiEndpoints {
  ApiEndpoints._();

  // Base URL
  static const String baseUrl = 'http://10.0.2.2:5050/api';
  // static const String baseUrl = 'http://192.168.1.64:5000/api/v1';
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // ============ Auth Endpoints ============
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static String userById(String id) => '/auth/user/$id';
}
