import 'package:flutter/material.dart';
import 'package:mygpt/models/message.dart';

class MessageContainer extends StatelessWidget {
  const MessageContainer({
    Key? key,
    required this.message,
  }) : super(key: key);

  final Message message;

  @override
  Widget build(BuildContext context) {
    final messageIsFromUs = message.sender == Sender.you;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: LayoutBuilder(builder: (context, constraints) {
        return Container(
          width: constraints.maxWidth / 2,
          color: messageIsFromUs ? Colors.teal : Colors.lightBlueAccent,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: messageIsFromUs
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        messageIsFromUs ? 'You' : 'ChatGPT',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
                Text(message.messageContent),
              ],
            ),
          ),
        );
      }),
    );
  }
}
