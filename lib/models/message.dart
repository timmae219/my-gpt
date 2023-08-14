import 'dart:async';

enum Sender {
  openai,
  you,
}

class Message {
  Message({
    required this.messageStream,
    required this.sender,
  });

  final StreamController<String> messageStream;
  final Sender sender;
  final List<String> _bufferedMessageContent = [];

  Stream<String> get stream => messageStream.stream;

  void addMessage(String content) {
    _bufferedMessageContent.add(content);
    messageStream.add(content);
  }

  Map<String, dynamic> toJson() {
    return {
      'role': sender == Sender.openai ? 'assistant' : 'user',
      'content': _bufferedMessageContent.join(' '),
    };
  }

  void dispose() {
    messageStream.close();
  }
}
