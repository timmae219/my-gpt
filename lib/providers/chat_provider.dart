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

    final messagesJson =
        jsonEncode(messages.map((message) => message.toJson()).toList());

    final requestHeaders = <String, String>{
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    };

    final requestBody = jsonEncode(<String, dynamic>{
      'model': "gpt-3.5-turbo",
      'messages': messagesJson,
      'stream': true,
    });

    final request = http.Request('POST', Uri.parse(apiBase));
    request
      ..headers.addAll(requestHeaders)
      ..body = requestBody;

    final http.StreamedResponse openAIResponse = await request.send();

    if (openAIResponse.statusCode == 200) {
      final messageStreamController = StreamController<String>();
      const messageStream = Stream<String>.empty();
      messageStreamController.addStream(messageStream);

      openAIResponse.stream.listen((value) {
        final decodedBytes = utf8.decode(value);
        // TODO: transform value!!
        messageStreamController.add(decodedBytes);
      });

      messages.add(Message(
          messageStream: messageStreamController, sender: Sender.openai));
    } else {
      messages.add(Message(
        messageStream: StreamController()
          ..addStream(Stream<String>.value('Something went wrong.')),
        sender: Sender.openai,
      ));
    }
  }
}
