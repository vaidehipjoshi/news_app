class URL {
 

  static String baseUrl = "http://b149b7f06d03.ngrok.io/api/";
  static String category = baseUrl + 'category';
  static String news = baseUrl + 'news';
  static String settings = baseUrl + 'settings';
  static String login = baseUrl + 'auth/login';
  static String changePass = baseUrl + 'change_password';

  static String addQuery(String url, Map<String, String> query) {
    url = url + '?';
    query.forEach((String key, String value) {
      url = url + '$key=$value&';
    });
    return url;
  }

  static String imageUrl(String imgUrl) {
    if (imgUrl == null || imgUrl.isEmpty) {
      return 'https://';
    }
    return 'http://b149b7f06d03.ngrok.io/storage/' + imgUrl;
  }
}
