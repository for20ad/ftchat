import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as socketIO;

void main() {
  runApp(ChatApp());
}

class ChatApp extends StatefulWidget {
  @override
  _ChatAppState createState() => _ChatAppState();
}

class _ChatAppState extends State<ChatApp> {
  TextEditingController messageController = TextEditingController();
  late socketIO.Socket socket;
  List<String> messages = [];

  @override
  void initState() {
    super.initState();
    socket = socketIO.io('https://node.dodoom.co.kr', <String, dynamic>{
      'transports': ['websocket'],
    });
    socket.on('chat_message_recive', (data) {
      addMessageToChat(data);
    });
  }

  void sendMessage() {
    final message = messageController.text;
    final userId = 'for21ad';
    final time = DateTime.now().toString();
    socket.emit('chat_message', {'message': message, 'userId': userId, 'time': time});
    messageController.clear();
  }

  void addMessageToChat(data) {
    setState(() {
      final message = data['message'];
      final userId = data['userId'];
      final time = data['time'];
      messages.add('$userId ($time): $message');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Chat App'),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(messages[index]),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      decoration: InputDecoration(hintText: 'Type a message'),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: sendMessage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
