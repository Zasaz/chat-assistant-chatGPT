import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/app_urls.dart';
import 'package:http/http.dart' as http;

class ChatRepository extends ChangeNotifier {
  Ref? ref;
  bool isLoading = false;

  Future sendMessage(
    String message,
  ) async {
    isLoading = true;
    notifyListeners();
    Map bodyData = {
      "model": "text-davinci-003",
      "prompt": message,
      "temperature": 0,
      "max_tokens": 100,
      "top_p": 1,
      "frequency_penalty": 0.0,
      "presence_penalty": 0.0,
      "stop": ["Human:", "AI:"]
    };

    final httpResponse = await http.post(
      Uri.parse(AppUrls.baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${AppUrls.bearerToken}',
      },
      body: json.encode(bodyData),
    );
    log('Status code: ${httpResponse.statusCode}');
    log('Body Response: ${httpResponse.body}');

    if (httpResponse.statusCode == 200) {
      isLoading = false;
      notifyListeners();
      var data = jsonDecode(httpResponse.body.toString());
      var msg = data['choices'][0]['text'];
      return msg;
    } else {
      isLoading = false;
      notifyListeners();
      return const ScaffoldMessenger(
        child: SnackBar(
          content: Text(
              'There was an error sending your message. Please try again.'),
        ),
      );
    }
  }
}
