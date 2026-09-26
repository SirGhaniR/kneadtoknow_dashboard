import '../config/api_config.dart';

String imageUrl(String? filename) {
  if (filename == null || filename.isEmpty) return '';
  return '${ApiConfig.imageBaseUrl}/$filename';
}
