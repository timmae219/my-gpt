import 'package:flutter/material.dart';
import 'package:mygpt/models/message.dart';
import 'package:mygpt/providers/chat_provider.dart';
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
    return ListView(
      children: messages
          .map((message) => Row(
                mainAxisAlignment: message.sender == Sender.you
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
                children: [
                  const Placeholder(
                      // TODO: add Messages Container (LayoutBuilder, half screen width, inner and outer padding)
                      ),
                ],
              ))
          .toList(),
    );
  }
}
