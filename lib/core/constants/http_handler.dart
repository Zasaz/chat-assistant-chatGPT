import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'app_utils.dart';

void httpErrorHandler({
  http.Response? response,
  BuildContext? context,
  VoidCallback? onSuccess,
}) {
  switch (response!.statusCode) {
    case 200:
      onSuccess!();
      break;
    case 400:
      AppUtils().showToast(
        jsonDecode(response.body)['response'],
        Colors.green,
      );
      break;
    case 500:
      AppUtils().showToast(jsonDecode(response.body)['msg'], Colors.red);
      break;
    default:
      AppUtils().showToast(response.body, Colors.blue);
  }
}
