import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mygpt/models/message.dart';
import 'package:http/http.dart' as http;

class ChatProvider with ChangeNotifier {
  List<Message> messages = [];

  Future<void> ask({required String question}) async {
    messages.add(Message(
      messageStream: StreamController()
        ..addStream(Stream<String>.value(question)),
      sender: Sender.you,
    ));

    const apiKey = String.fromEnvironment('OPENAI_API_KEY');
    const apiBase = 'https://api.openai.com/v1/chat/completions';

    final requestHeaders = <String, String>{
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    };

    final requestBody = jsonEncode(<String, dynamic>{
      'model': "gpt-3.5-turbo",
      // TODO: add messages, question and stream = True
    });

    final request = http.Request('POST', Uri.parse(apiBase));
    request
      ..headers.addAll(requestHeaders)
      ..body = requestBody;

    final http.StreamedResponse openAIResponse = await request.send();

    // TODO: grep response stream
  }
}
