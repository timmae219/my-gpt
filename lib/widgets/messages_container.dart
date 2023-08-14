import 'package:flutter/material.dart';
import 'package:mygpt/models/message.dart';

class MessagesContainer extends StatefulWidget {
  const MessagesContainer({
    super.key,
  });

  @override
  State<MessagesContainer> createState() => _MessagesContainerState();
}

class _MessagesContainerState extends State<MessagesContainer> {
  final List<Message> messages = [];

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      child: Placeholder(), // TODO: add MessagesContainer
    );
  }
}
