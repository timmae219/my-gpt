import 'package:flutter/material.dart';
import 'package:mygpt/models/message.dart';
import 'package:mygpt/providers/chat_provider.dart';
import 'package:mygpt/widgets/message_container.dart';
import 'package:provider/provider.dart';

class MessagesContainer extends StatefulWidget {
  const MessagesContainer({
    super.key,
  });

  @override
  State<MessagesContainer> createState() => _MessagesContainerState();
}

class _MessagesContainerState extends State<MessagesContainer> {
  @override
  Widget build(BuildContext context) {
    final messages = Provider.of<ChatProvider>(context).messages;
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: messages
              .map((message) => Row(
                    mainAxisAlignment: message.sender == Sender.you
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: [MessageContainer(message: message)],
                  ))
              .toList(),
        ),
      ),
    );
  }
}
