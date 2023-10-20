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
  FocusNode messageFocusNode = FocusNode();


  final userId = 'for22ad';

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
    messageFocusNode.requestFocus();
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
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus(); // 키보드 닫기 이벤트
          },
          child: Column(
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
                        keyboardType: TextInputType.text,
                        controller: messageController,
                        onSubmitted: sendMessage,
                        focusNode: messageFocusNode,
                        decoration: InputDecoration(
                          hintText: "메시지 입력",
                        ),
                      ),
                    ),

                    IconButton(
                      onPressed: () async{
                        sendMessage(messages);
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
      ),
    );
  }
}

