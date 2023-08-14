import 'package:flutter/material.dart';

class MessageInputPanel extends StatelessWidget {
  const MessageInputPanel({
    super.key,
  });

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
                ),
              ),
            )),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.send),
            )
          ],
        ),
      ),
    );
  }
}
