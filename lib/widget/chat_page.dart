import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as socketIO;
import 'package:ftchat/widget/chat_message.dart';

class ChatApp extends StatefulWidget {
  @override
  _ChatAppState createState() => _ChatAppState();
}

class _ChatAppState extends State<ChatApp> {
  TextEditingController messageController = TextEditingController();
  late socketIO.Socket socket;
  List<Map<String, dynamic>> messages = [];
  GlobalKey<AnimatedListState> _animListKey = GlobalKey<AnimatedListState>();
  final userId = 'for21ad';

  @override
  void initState() {
    super.initState();
    socket = socketIO.io('https://node.dodoom.co.kr', <String, dynamic>{
      'transports': ['websocket'],
    });
    socket.on('chat_message_receive', (data) {
      addMessageToChat(data);
    });
  }

  void sendMessage( data ) {
    final message = messageController.text;
    final time = DateTime.now().toString();
    socket.emit('chat_message', {'message': message, 'userId': userId, 'time': time});
    messageController.clear();
  }

  void addMessageToChat(data) {
    setState(() {
      messages.insert(0,data);
      _animListKey.currentState?.insertItem(0);
    });
  }

  Widget _buildItem(context, index, animation) {
    final data = messages[index];
    final isMe = data['userId'] == userId;
    return ChatMessage(data, animation: animation, isMe: isMe);
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
              child: AnimatedList(
                key: _animListKey,
                reverse: true,
                initialItemCount: messages.length,
                itemBuilder: _buildItem,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [


                  Expanded(
                    child: TextField(
                      controller: messageController,
                      onSubmitted: sendMessage,
                      decoration: InputDecoration(
                        hintText: "메시지 입력",
                      ),
                    ),
                  ),

                  IconButton(
                    onPressed: () async{
                      sendMessage;
                    },
                    icon: Icon(
                      Icons.send,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

