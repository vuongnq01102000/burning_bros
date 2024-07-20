class AppConfig {
  final String baseUrl;
  final Map<String, String> headers;
  
  AppConfig({
    required this.baseUrl,
    this.headers = const {},
  });
}
