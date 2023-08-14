import 'package:flutter/material.dart';
import 'package:mygpt/constants.dart';
import 'package:mygpt/widgets/message_input_panel.dart';
import 'package:mygpt/widgets/messages_container.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyGPT',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: myGptBaseColor),
        useMaterial3: true,
      ),
      home: const MainView(),
    );
  }
}

class MainView extends StatelessWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: myGptBaseColor,
        title: const Text('MyGPT'),
      ),
      body: const Column(
        children: [
          MessagesContainer(),
          MessageInputPanel(),
        ],
      ),
    );
  }
}
