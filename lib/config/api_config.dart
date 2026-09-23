class ApiConfig {
  static const String _origin = 'http://192.168.1.25:8000';

  static const String baseUrl = '$_origin/api';
  static const String imageBaseUrl = '$_origin/uploaded_images';

  static const String login = '/login';
  static const String logout = '/logout';
  static const String me = '/me';
  static const String dashboardStats = '/dashboard/stats';
  static const String news = '/news';
  static const String gallery = '/gallery';
  static const String contacts = '/contacts';
  static const String contactInfo = '/contact-info';

  static const String tokenKey = 'auth_token';
}
