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
      )..addMessage(question),
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
      'stream': false,
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
      const messageStream = Stream<String>.empty();
      await messageStreamController.addStream(messageStream);

      openAIResponse.stream.listen((value) {
        final decodedBytes = utf8.decode(value);
        final resultingToken = decodedBytes.replaceAll('data:', '');
        messageStreamController.add(resultingToken);
        print(resultingToken);
      });

      messages.add(Message(
          messageStream: messageStreamController, sender: Sender.openai));
    } else {
      print('Request failed with status code ${openAIResponse.statusCode}');
      messages.add(
        Message(messageStream: StreamController(), sender: Sender.openai)
          ..addMessage('Sorry, something went wrong.'),
      );
    }

    notifyListeners();
  }
}
