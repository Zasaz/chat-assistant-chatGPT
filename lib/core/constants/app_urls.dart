import 'dart:convert';

class AppUrls {
  AppUrls._();

  static String baseUrl = 'https://api.openai.com/v1/completions';
  static String bearerToken =
      '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';
}

String prettyJson(jsonObject) {
  var encoder = const JsonEncoder.withIndent("     ");
  return encoder.convert(jsonObject);
}
