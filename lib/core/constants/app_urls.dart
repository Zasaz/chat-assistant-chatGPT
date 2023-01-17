import 'dart:convert';

class AppUrls {
  AppUrls._();

  static String baseUrl = 'https://api.openai.com/v1/completions';
  static String bearerToken =
      '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'; // Replace your own key
}

String prettyJson(jsonObject) {
  var encoder = const JsonEncoder.withIndent("     ");
  return encoder.convert(jsonObject);
}
