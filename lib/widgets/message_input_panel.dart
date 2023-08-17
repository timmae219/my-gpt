import 'package:flutter/material.dart';
import 'package:mygpt/providers/chat_provider.dart';
import 'package:provider/provider.dart';

class MessageInputPanel extends StatefulWidget {
  const MessageInputPanel({
    super.key,
  });

  @override
  State<MessageInputPanel> createState() => _MessageInputPanelState();
}

class _MessageInputPanelState extends State<MessageInputPanel> {
  final inputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
          border: Border.all(color: Colors.black),
        ),
        child: Row(
          children: [
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: TextFormField(
                  maxLines: null,
                  controller: inputController,
                  decoration: const InputDecoration(
                    hintText: 'Ask me something...',
                  ),
                ),
              ),
            )),
            IconButton(
              onPressed: () {
                Provider.of<ChatProvider>(context, listen: false)
                    .ask(question: inputController.value.text);
                setState(() {
                  inputController.text = '';
                });
              },
              icon: const Icon(Icons.send),
            )
          ],
        ),
      ),
    );
  }
}
