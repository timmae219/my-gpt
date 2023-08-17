import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mygpt/models/message.dart';
import 'package:http/http.dart' as http;

class ChatProvider with ChangeNotifier {
  List<Message> messages = [];

  Future<void> ask({required String question}) async {
    messages.add(
      Message(
        messageStream: StreamController(),
        sender: Sender.you,
      )..addToken(question),
    );
    notifyListeners();

    print('Added question to messages: $question');

    const apiKey = String.fromEnvironment('OPENAI_API_KEY');
    const apiBase = 'https://api.openai.com/v1/chat/completions';

    final requestHeaders = <String, String>{
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    };

    final requestBody = jsonEncode(<String, dynamic>{
      'model': "gpt-3.5-turbo",
      'messages': messages,
      'stream': true,
    });

    print('Encoded request body: $requestBody');

    final request = http.Request('POST', Uri.parse(apiBase));
    request
      ..headers.addAll(requestHeaders)
      ..body = requestBody;

    final http.StreamedResponse openAIResponse = await request.send();

    if (openAIResponse.statusCode == 200) {
      print('Response successful!');
      final messageStreamController = StreamController<String>();

      final openaiMessage = Message(
          messageStream: messageStreamController, sender: Sender.openai);

      messages.add(openaiMessage);
      notifyListeners();

      openAIResponse.stream.listen((value) async {
        final decodedBytes = utf8.decode(value);
        final rawJsonBunch = decodedBytes.replaceAll('data: ', '').trim();

        final lines = rawJsonBunch.split('\n\n');

        for (final rawJson in lines) {
          if (rawJson != '[DONE]') {
            final decodedFullJson = jsonDecode(rawJson);
            final choice = decodedFullJson['choices'][0];
            if (choice['finish_reason'] == 'stop') {
              await messageStreamController.close();
              return;
            } else {
              final content = choice['delta']['content'];
              messageStreamController.add(content);
              openaiMessage.addToken(content);
              notifyListeners();
            }
          } else {
            await messageStreamController.close();
          }
        }
      });
    } else {
      print('Request failed with status code ${openAIResponse.statusCode}');
      messages.add(
        Message(messageStream: StreamController(), sender: Sender.openai)
          ..addToken('Sorry, something went wrong.'),
      );
      notifyListeners();
    }
  }
}
